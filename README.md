The COG database provides functional protein annotations based on groups conserved across multiple genomes ([Tatusov, 1997](https://www.science.org/doi/10.1126/science.278.5338.631)). COGs are useful in larger genomic studies, and, as such,
over the next decades, the database has been greatly expanded.

This repository provides a handy way or accessing the most recent version of the COG annotations ([COG 2024](https://www.ncbi.nlm.nih.gov/research/cog/)) for one of the model organisms I used in my PhD, _Pseudomonas putida_ KT2440, as a plain text table.

## Repository structure

The repository is composed 3 main R scripts:

- `download-cog.R` : this script downloads the entire COG24 database from NCBI's FTP server. The database is comprised of three files (cog-24.cog.csv, cog-24.def.tab, and cog-24.fun.tab), which are not hosted in this repository.
- `database.R` : this script creates an SQLite database combining the files downloaded above, parses them, and saves the resulting table as a TSV file.
- `utils.R` : this script contains a heper function for parsing the COG functions file.
- `ppuCog.tsv` : the final plain-text table relating genomic loci to COG annotations for _P. putida_ KT2440.

## Using this repo for other organisms
Since the entirety of the COG database is downloaded and processed when running these scripts, it is possible to generate a plain-text COG table for virtually any organism deposited in RefSeq using the `database.R` script.
To do so, replace _P. putida_'s genome assembly ID to the target organism's ID in line 33 of the script (please see below). The packages `DBI`, `dplyr` and `readr`, are required for running this script.

```
gene2cog <- DBI::dbGetQuery(cog24, "
        SELECT GENE_ID, COG_ID
        FROM 'cog'
        WHERE ASSEMBLY_ID = 'GCF_000007565.2' # edit this line to change the target organism
      ")
```

## Information
If you have any questions or feedback, please feel free to contact me at guiviana@proton.me
