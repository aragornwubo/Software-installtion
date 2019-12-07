#!/usr/bin/env nextflow

params.in = '' 
params.t = 8
params.ref = ''
params.outfmt = 'paf'
pbdata = file(params.in)

/*
 * Mapping fastq or fasta format pacbio subreads to reference using minimap2
 */
process minimap2_pb_fastx {
    input:
    file 'pbfile' from pbdata
    
    output:
    file "${params.in%fast[aq]}sam" into samfile
    stdout channel

    """
    if [ ! -f "${params.in}.fai"]; then
    samtools faidx $params.in
    fi
    if [ "$params.outfmt" = "sam" ]; then
        minimap2 -t $params.t -ax map-pb $params.t $params.in -o ${params.in%fast[aq]}sam
    else
        minimap2 -t $params.t -x map-pb $params.t $params.in -o ${params.in%fast[aq]}paf
    fi
    """

channel.subscribe {print "$it"}

