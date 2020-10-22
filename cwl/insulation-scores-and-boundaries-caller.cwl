#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/4dn-insulation-scores-and-boundaries-caller:v1"

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

  binsize:
    type: int
    inputBinding:
      position: 3
    default: 5000

  windowsize:
    type: int
    inputBinding:
      position: 4
    default: 100000

  boundaries_weak:
    type: float
    inputBinding:
      position: 5
    default: 0.2

  boundaries_strong:
    type: float
    inputBinding:
      position: 6
    default: 0.5

  cutoff:
    type: int
    inputBinding:
      position: 7
    default: 2

  pixels_frac:
    type: float
    inputBinding:
      position: 8
    default: 0.66

outputs:
  bwfile:
    type: File
    outputBinding:
      glob: "$(inputs.outdir + '/' + '*.bw')"

  bedfile:
    type: File
    outputBinding:
      glob: "$(inputs.outdir + '/' +'*.bed.gz')"

baseCommand: ["run-insulation-scores-and-boundaries-caller.sh"]
