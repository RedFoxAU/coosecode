# List of folder names to create
$folders = @(
    "ICTSAS432 - Identify and resol",
    "BSBXCS404 - Contribute to cybe",
    "ICTICT426 - Identify and evalu",
    "ICTICT443 - Work collaborative",
    "ICTNWK421 - Install, configure",
    "ICTNWK424 - Install and operat",
    "ICTTEN434 - Install, configure",
    "ICTNWK420 - Install and config",
    "ICTICT449 - Use version contro",
    "ICTCLD301 - Evaluate character",
    "ICTDBS416 - Create basic relat",
    "ICTICT424 - Address cyber secu",
    "ICTICT451 - Comply with IP, et",
    "ICTNWK422 - Install and manage",
    "ICTNWK423 - Manage network and",
    "ICTNWK429 - Install hardware t",
    "ICTPRG302 - Apply introductory",
    "ICTPRG438 - Configure and main",
    "ICTWEB451 - Apply structured q",
    "ICTICT449 - Use version contro",
    "ICTPRG302 - Apply introductory",
    "ICTPRG430 - Apply introductory",
    "ICTSAS432 - Identify and resol",
    "BSBXCS301 - Protect own person",
    "BSBXCS302 - Identify and repor",
    "BSBXCS303 - Securely manage pe",
    "ICTPRG434 - Automate processes",
    "ICTPRG435 - Write scripts for ",
    "BSBXCS404 - Contribute to cybe",
    "ICTPRG429 - Maintain open-sour",
    "ICTPRG431 - Apply query langua",
    "ICTPRG432 - Develop data-drive",
    "ICTPRG433 - Test software deve",
    "ICTPRG436 - Develop mobile app",
    "ICTPRG437 - Build a user inter",
    "ICTPRG439 - Use pre-existing c",
    "ICTPRG440 - Apply introductory",
    "ICTPRG443 - Apply intermediate",
    "ICTWEB441 - Produce basic clie",
    "ICTWEB452 - Create a markup la",
    "BSBCRT404 - Apply advanced cri"
)

# Create each folder in the current directory
foreach ($folder in $folders) {
    New-Item -ItemType Directory -Name $folder -Force
}

Write-Host "Folders created successfully."
