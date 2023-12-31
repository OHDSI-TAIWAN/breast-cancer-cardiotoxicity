library(breastCancer)

# Optional: specify where the temporary files (used by the Andromeda package) will be created:
options(andromedaTempFolder = "/tmp/andromedaTemp")

# Maximum number of cores to be used:
maxCores <- parallel::detectCores() - 1

# The folder where the study intermediate and result files will be written:
outputFolder <- "./output"

# Details for connecting to the server:
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "sql server",
                                                                server='127.0.0.1',
                                                                user = 'user',
                                                                password = 'password',
                                                                pathToDriver = '~/.config/driver/'
                                                                )

# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "OHDSI_V5.dbo"

# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "OHDSI_ACHILLES.dbo"
cohortTable <- "bcCohort"

# Some meta-information that will be used by the export function:
databaseId <- "TMU_CRD"
databaseName <- "TMU CRD"
databaseDescription <- "TMU CRD"

# For some database platforms (e.g. Oracle): define a schema that can be used to emulate temp tables:
options(sqlRenderTempEmulationSchema = NULL)

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription,
        verifyDependencies = TRUE,
        createCohorts = TRUE,
        synthesizePositiveControls = TRUE,
        runAnalyses = TRUE,
        packageResults = TRUE,
        maxCores = maxCores)

resultsZipFile <- file.path(outputFolder, "export", paste0("Results_", databaseId, ".zip"))
dataFolder <- file.path(outputFolder, "shinyData")

# You can inspect the results if you want:
prepareForEvidenceExplorer(resultsZipFile = resultsZipFile, dataFolder = dataFolder)
launchEvidenceExplorer(dataFolder = dataFolder, blind = F, launch.browser = T)

# Upload the results to the OHDSI SFTP server:
#privateKeyFileName <- ""
#userName <- ""
#uploadResults(outputFolder, privateKeyFileName, userName)
