@{
    Description          = 'Surgical updates on .psd1 files'
    ModuleVersion        = '0.0.1'
    HelpInfoURI          = 'https://pages.github.com/fsackur/Manifest'

    GUID                 = '579e4fdf-5961-4d89-b9a0-c375c2077c24'

    RequiredModules      = @()

    Author               = 'Freddie Sackur'
    CompanyName          = 'DustyFox'
    Copyright            = '(c) 2021 Freddie Sackur. All rights reserved.'

    RootModule           = 'Manifest.psm1'

    FunctionsToExport    = @(
        '*'
    )

    PrivateData          = @{
        PSData = @{
            LicenseUri = 'https://raw.githubusercontent.com/fsackur/Manifest/main/LICENSE'
            ProjectUri = 'https://github.com/fsackur/Manifest'
            Tags       = @(
                'Psd1',
                'Psd',
                'Manifest',
                'Module',
                'Build'
            )
        }
    }
}
