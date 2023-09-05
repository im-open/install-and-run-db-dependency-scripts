# install-and-run-db-dependency-scripts

A GitHub Action that takes in a list of dependency scripts for a database, downloads them, and runs them on the specified database.

## Index <!-- omit in toc -->

- [install-and-run-db-dependency-scripts](#install-and-run-db-dependency-scripts)
  - [Inputs](#inputs)
  - [Usage Examples](#usage-examples)
  - [Contributing](#contributing)
    - [Incrementing the Version](#incrementing-the-version)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)

## Inputs

| Parameter                  | Is Required | Default | Description                                                                                                                                                                                        |
| -------------------------- | ----------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `db-server-name`           | true        | N/A     | The server where the dependency files will be run.                                                                                                                                                 |
| `db-name`                  | true        | N/A     | The name of the database where the dependency files will run.                                                                                                                                      |
| `dependency-list`          | true        | N/A     | A json string containing a list of objects with the name of the dependency package, the version,the url where the package is stored, and optionally the auth token needed to download the package. |
| `use-integrated-security`  | true        | false   | Use domain integrated security. If false, a db-username and db-password should be specified. If true, those parameters will be ignored if specified.                                               |
| `db-username`              | false       | N/A     | The username to use to login to the database. This is required if use-integrated-security is false, otherwise it's optional and will be ignored.                                                   |
| `db-password`              | false       | N/A     | The password for the user logging in to the database. This is required if use-integrated-security is false, otherwise it's optional and will be ignored.                                           |
| `trust-server-certificate` | false       | false   | A boolean that controls whether or not to validate the SQL Server TLS certificate.                                                                                                                 |

The `dependency-list` should be an array of objects with the following properties:

```json
{
  "version": "1.0.0",
  "packageName": "some_package",
  "nugetUrl": "https://www.some-nuget-repo.com",
  "authToken": "ghp_fdijlfdsakeizdkliejfezejw"
}
```

**Notes** 
* The `authToken` property is optionally used for nuget sources that require a bearer token, such as GitHub Packages. It should not be included if it is unnecessary.
* The `nugetUrl` for GitHub Packages can be pretty tricky to lookup, so for reference the pattern is as follows: `https://nuget.pkg.github.com/<owner>/download/<package-name>/<version>/<file-name>.nupkg`. Here's an example of how that could look if this repo were publishing a package called `MyDbObject`: `https://nuget.pkg.github.com/im-open/download/MyDbObject/1.0.0/MyDbObject.1.0.0.nupkg`.

## Usage Examples

```yml
jobs:
  download-and-run-db-dependencies:
    runs-on: [self-hosted, windows-2019]
    steps:
      # For this example we'll retrieve packages from GitHub Packages 
      - name: Authenticate with GitHub Packages on Windows
        uses: im-open/authenticate-with-gh-package-registries@v1
        with:
          github-token: ${{ secrets.MY_GH_PACKAGES_ACCESS_TOKEN }} # Token has read:packages scope and is authorized for each of the orgs
          orgs: 'my-org'

      - name: Download and Run Dependencies
        # You may also reference the major or major.minor version
        uses: im-open/install-and-run-db-dependency-scripts@v1.2.0
        with:
          db-server-name: 'localhost,1433'
          db-name: 'LocalDb'
          trust-server-certificate: 'true'
          dependency-list: '[{"version":"1.0.0","packageName":"dbo.Something","nugetUrl":"https://nuget.pkg.github.com/my-org/download/Something/1.0.0/dbo.Something.1.0.0.nupkg","authToken":"ghp_dkfsjakldafl"},{"version":"1.2.0","packageName":"dbo.SomeOtherThing","nugetUrl":"https://nuget.pkg.github.com/my-org/download/SomeOtherThing/1.2.0/dbo.SomeOtherThing1.2.0.nupkg","authToken":"ghp_dkfsjakldafl"}]'
```

## Contributing

When creating new PRs please ensure:

1. For major or minor changes, at least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version](#incrementing-the-version).
1. The action code does not contain sensitive information.

When a pull request is created and there are changes to code-specific files and folders, the `auto-update-readme` workflow will run.  The workflow will update the action-examples in the README.md if they have not been updated manually by the PR author. The following files and folders contain action code and will trigger the automatic updates:

- `action.yml`
- `src/**`

There may be some instances where the bot does not have permission to push changes back to the branch though so this step should be done manually for those branches. See [Incrementing the Version](#incrementing-the-version) for more details.

### Incrementing the Version

The `auto-update-readme` and PR merge workflows will use the strategies below to determine what the next version will be.  If the `auto-update-readme` workflow was not able to automatically update the README.md action-examples with the next version, the README.md should be updated manually as part of the PR using that calculated version.

This action uses [git-version-lite] to examine commit messages to determine whether to perform a major, minor or patch increment on merge.  The following table provides the fragment that should be included in a commit message to active different increment strategies.
| Increment Type | Commit Message Fragment                     |
| -------------- | ------------------------------------------- |
| major          | +semver:breaking                            |
| major          | +semver:major                               |
| minor          | +semver:feature                             |
| minor          | +semver:minor                               |
| patch          | *default increment type, no comment needed* |

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).

[git-version-lite]: https://github.com/im-open/git-version-lite
