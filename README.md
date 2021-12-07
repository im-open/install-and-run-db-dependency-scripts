# install-and-run-db-dependency-scripts

A GitHub Action that takes in a list of dependency scripts for a database, downloads them, and runs them on the specified database.

## Index
 
- [install-and-run-db-dependency-scripts](#install-and-run-db-dependency-scripts)
  - [Index](#index)
  - [Inputs](#inputs)
  - [Example](#example)
  - [Contributing](#contributing)
    - [Incrementing the Version](#incrementing-the-version)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)

## Inputs
| Parameter                 | Is Required | Default | Description                                                                                                                                              |
| ------------------------- | ----------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `db-server-name`          | true        | N/A     | The server where the dependency files will be run.                                                                                                       |
| `db-name`                 | true        | N/A     | The name of the database where the dependency files will run.                                                                                            |
| `dependency-list`         | true        | N/A     | A json string containing a list of objects with the name of the dependency package, the version, and the url where the package is stored.                |
| `use-integrated-security` | true        | false   | Use domain integrated security. If false, a db-username and db-password should be specified. If true, those parameters will be ignored if specified.     |
| `username`                | true        | N/A     | The username to use to login to the database. This is required if use-integrated-security is false, otherwise it's optional and will be ignored.         |
| `password`                | true        | N/A     | The password for the user logging in to the database. This is required if use-integrated-security is false, otherwise it's optional and will be ignored. |

The `dependency-list` should be an array of objects with the following properties:
```json
{
  "version": "1.0.0",
  "packageName": "some_package",
  "nugetUrl": "https://www.some-nuget-repo.com"
}
```

## Example

```yml
jobs:
  download-and-run-db-dependencies:
    runs-on: [self-hosted, windows-2019]
    steps:
      # For this example we'll retrieve packages from GitHub Packages 
      - name: Authenticate with GitHub Packages on Windows
        uses: im-open/authenticate-with-gh-packages-for-nuget@v1.0.5
        with:
          github-token: ${{ secrets.MY_GH_PACKAGES_ACCESS_TOKEN }} # Token has read:packages scope and is authorized for each of the orgs
          orgs: 'my-org'

      - name: Download and Run Dependencies
        uses: im-open/install-and-run-db-dependency-scripts@v1.2.0
        with:
          db-server-name: 'localhost,1433'
          db-name: 'LocalDb'
          dependency-list: '[{"version":"1.0.0","packageName":"dbo.Something","nugetUrl":"https://nuget.pkg.github.com/my-org/my-repo/dbo.Something.nupkg"},{"version":"1.2.0","packageName":"dbo.SomeOtherThing","nugetUrl":"https://nuget.pkg.github.com/my-org/my-repo/dbo.SomeOtherThing.nupkg"}]'
```


## Contributing

When creating new PRs please ensure:
1. For major or minor changes, at least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version](#incrementing-the-version).
2. The `README.md` example has been updated with the new version.  See [Incrementing the Version](#incrementing-the-version).
3. The action code does not contain sensitive information.

### Incrementing the Version

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
