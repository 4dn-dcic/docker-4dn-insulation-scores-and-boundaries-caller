#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/4dn-insulation-score-and-boundaries-caller:v1"

- class: "InlineJavascriptRequirement"

inputs:
  mcoolfile:
    type: File
    inputBinding:
      position: 1

  outdir:
    type: string
    inputBinding:
      position: 2
    default: "."

  chromsizes:
    type: File
    inputBinding:
      position: 3

  boundaries_cutoff_1:
    type: float
    inputBinding:
      position: 4
    default: 0.2

  boundaries_cutoff_2:
    type: float
    inputBinding:
      position: 5
    default: 0.5

  binsize:
    type: int
    inputBinding:
      position: 6
    default: 5000

  windowsize:
    type: int
    inputBinding:
      position: 7
    default: 100000

  cutoff:
    type: int
    inputBinding:
      position: 8
    default: 2

  pixels_frac:
    type: float
    inputBinding:
      position: 9
    default: 0.66

outputs:
  bwfile:
    type: File
    outputBinding:
      glob: "$(inputs.outdir + '/' + '*.bw')"

  bedfile1:
    type: File
    outputBinding:
      glob: "$(inputs.outdir + '/*' + inputs.boundaries_cutoff_1 + '.bed.beddb')"

  bedfile2:
    type: File
    outputBinding:
      glob: "$(inputs.outdir + '/*' + inputs.boundaries_cutoff_2 + '.bed.beddb')"

baseCommand: ["run-insulation-score-and-boundaries-caller.sh"]
