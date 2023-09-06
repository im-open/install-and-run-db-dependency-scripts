# install-and-run-db-dependency-scripts

A GitHub Action that takes in a list of dependency scripts for a database, downloads them, and runs them on the specified database.

## Index <!-- omit in toc -->

- [install-and-run-db-dependency-scripts](#install-and-run-db-dependency-scripts)
  - [Inputs](#inputs)
  - [Usage Examples](#usage-examples)
  - [Contributing](#contributing)
    - [Incrementing the Version](#incrementing-the-version)
    - [Source Code Changes](#source-code-changes)
    - [Updating the README.md](#updating-the-readmemd)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)

## Inputs

| Parameter                  | Is Required | Default | Description                                                                                                                                                                                        |
|----------------------------|-------------|---------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
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

- The `authToken` property is optionally used for nuget sources that require a bearer token, such as GitHub Packages. It should not be included if it is unnecessary.
- The `nugetUrl` for GitHub Packages can be pretty tricky to lookup, so for reference the pattern is as follows: `https://nuget.pkg.github.com/<owner>/download/<package-name>/<version>/<file-name>.nupkg`. Here's an example of how that could look if this repo were publishing a package called `MyDbObject`: `https://nuget.pkg.github.com/im-open/download/MyDbObject/1.0.0/MyDbObject.1.0.0.nupkg`.

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

When creating PRs, please review the following guidelines:

- [ ] The action code does not contain sensitive information.
- [ ] At least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version] for major and minor increments.
- [ ] The README.md has been updated with the latest version of the action.  See [Updating the README.md] for details.

### Incrementing the Version

This repo uses [git-version-lite] in its workflows to examine commit messages to determine whether to perform a major, minor or patch increment on merge if [source code] changes have been made.  The following table provides the fragment that should be included in a commit message to active different increment strategies.

| Increment Type | Commit Message Fragment                     |
|----------------|---------------------------------------------|
| major          | +semver:breaking                            |
| major          | +semver:major                               |
| minor          | +semver:feature                             |
| minor          | +semver:minor                               |
| patch          | *default increment type, no comment needed* |

### Source Code Changes

The files and directories that are considered source code are listed in the `files-with-code` and `dirs-with-code` arguments in both the [build-and-review-pr] and [increment-version-on-merge] workflows.  

If a PR contains source code changes, the README.md should be updated with the latest action version.  The [build-and-review-pr] workflow will ensure these steps are performed when they are required.  The workflow will provide instructions for completing these steps if the PR Author does not initially complete them.

If a PR consists solely of non-source code changes like changes to the `README.md` or workflows under `./.github/workflows`, version updates do not need to be performed.

### Updating the README.md

If changes are made to the action's [source code], the [usage examples] section of this file should be updated with the next version of the action.  Each instance of this action should be updated.  This helps users know what the latest tag is without having to navigate to the Tags page of the repository.  See [Incrementing the Version] for details on how to determine what the next version will be or consult the first workflow run for the PR which will also calculate the next version.

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/main/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2023, Extend Health, LLC. Code released under the [MIT license](LICENSE).

<!-- Links -->
[Incrementing the Version]: #incrementing-the-version
[Updating the README.md]: #updating-the-readmemd
[source code]: #source-code-changes
[usage examples]: #usage-examples
[build-and-review-pr]: ./.github/workflows/build-and-review-pr.yml
[increment-version-on-merge]: ./.github/workflows/increment-version-on-merge.yml
[git-version-lite]: https://github.com/im-open/git-version-lite
