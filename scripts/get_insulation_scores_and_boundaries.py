from cooltools.insulation import calculate_insulation_score
from cooltools.insulation import find_boundaries
import cooler
import bioframe
import click
import sys
import pandas as pd
import numpy as np


@click.command()
@click.argument('mcoolfile')
@click.argument('outdir')
@click.argument('filename')
@click.option('--binsize', default=-1)
@click.option('--window', default=100000)
@click.option('--bweak', default=0.2)
@click.option('--bstrong', default=0.5)
@click.option('--cutoff', default=2)
@click.option('--pixels_frac', default=0.66)
def main(mcoolfile, outdir, filename, binsize, window, bweak, bstrong, cutoff, pixels_frac):
    f = mcoolfile

    # Get the list of resolutions in the mcool file
    cooler_list = cooler.fileops.list_coolers(f)
    old_version = False

    # gets the resolutions from a file in a older version of cooler
    if not any([res for res in cooler_list if '/resolutions/' in res]):
        old_version = True
        binsize_list = []
        for res in cooler_list:
            cooler_path = str(f)+'::' + res
            c = cooler.Cooler(cooler_path)
            binsize_list.append(int(c.binsize))
    else:
        binsize_list = []
        for res in cooler_list:
            binsize_list.append(int(res.split('/')[-1]))

    # Check the input parameters
    if binsize == -1:
        binsize = min(binsize_list)
    else:
        if binsize in binsize_list:
            if window % binsize != 0:
                print("Error: Window size must be multiple of binsize")
                sys.exit()
        else:
            print("Error: This binsize is not available in this mcool file. This is the list of binsizes availables:")
            print(binsize_list)
            sys.exit()

    # Creates a cooler object
    if old_version:
        res_list = []
        for res in cooler_list:
            res_list.append(int(res.split('/')[-1]))
            res_index = max(res_list)

        cooler_path = str(f) + '::' + str(res_index)
    else:
        cooler_path = str(f) + '::' + cooler_list[binsize_list.index(binsize)]
    c = cooler.Cooler(cooler_path)
    print(c)

    # Gets the chromsizes
    chromsizes = pd.Series(c.chroms()[:]['length'].values, index=c.chroms()[:]['name'].values)

    # calculate insulation score
    ins_table = calculate_insulation_score(c, window)

    # Find boundaries
    ins_table = find_boundaries(ins_table, pixels_frac, cutoff)

    # Filter out insulation score in which pixels are less than 66% of the max number of pixels
    icutoff = pow((window / binsize), 2) * pixels_frac

    ins_table_filtered = ins_table[ins_table[f'n_valid_pixels_{window}'] >= icutoff]
    # Convert to BigWig
    bioframe.to_bigwig(ins_table_filtered, chromsizes,
                       f'{outdir}/{filename}.bw',
                       f'log2_insulation_score_{window}')

    # Classify the boundaries as strong and week
    # strong boundaries >= 0.5,  weak 0.2>= and < 0.5
    boun_table = ins_table_filtered[ins_table_filtered[f'boundary_strength_{window}'] >= bweak].copy()
    boun_table['boundary_classification'] = np.where(boun_table[f'boundary_strength_{window}'] >= bstrong, 'Strong', 'Weak')
    # Filter boundaries abover thresholds
    columns = ['chrom', 'start', 'end', 'boundary_classification', f'boundary_strength_{window}']
    boun_table.to_csv(f'{outdir}/{filename}_boundaries.bed', sep='\t', header=None, index=False, columns=columns)


if __name__ == "__main__":
    main()
