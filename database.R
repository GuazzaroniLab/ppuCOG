source("utils.R")

# initialize the database
cog24 <- DBI::dbConnect(RSQLite::SQLite(), "")

# append COG table
DBI::dbWriteTable(cog24,
                  name = "cog",
                  value = readr::read_csv("cog-24.cog.csv",
                                          col_names = c("GENE_ID", "ASSEMBLY_ID", "PROTEIN_ID",
                                                        "PROTEIN_LENGTH", "COG_FOOTPRINT_COORDS",
                                                        "COG_FOOTPRINT_LENGTH", "COG_ID"),
                                          col_select = 1:7))

# append cog definitions table
DBI::dbWriteTable(cog24,
                  name = "cog.def",
                  value = readr::read_tsv("cog-24.def.tab",
                  col_names = c("COG_ID", "COG_CATEGORY", "COG_NAME", "ASSOC_GENE", "PATHWAY", "PUBMED_ID", "PDB_ID")))


# append COG functions table
DBI::dbWriteTable(cog24,
                  name = "cog.fun",
                  value = readCogFun("cog-24.fun.tab"))


DBI::dbListTables(cog24)

gene2cog <- DBI::dbGetQuery(cog24, "
        SELECT GENE_ID, COG_ID
        FROM 'cog'
        WHERE ASSEMBLY_ID = 'GCF_000007565.2' -- edit this line to change the target organism
      ")

cogfunctions <- DBI::dbGetQuery(cog24, "SELECT * FROM 'cog.fun'")

cogdefinitions <- DBI::dbGetQuery(cog24, "SELECT * FROM 'cog.def'")

DBI::dbDisconnect(cog24)


ppuCog <- dplyr::left_join(gene2cog, cogdefinitions) |>
     dplyr::select(-ASSOC_GENE, -PUBMED_ID, -PDB_ID) |>
     tidyr::separate_longer_position(COG_CATEGORY, 1) |> # some cog desc. may have more than 1 func annot to them
     dplyr::left_join(cogfunctions, by = "COG_CATEGORY")

readr::write_tsv(ppuCog, "ppuCog.tsv")
