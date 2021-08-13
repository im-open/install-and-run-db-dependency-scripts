# install-and-run-db-dependency-scripts

A GitHub Action that takes in a list of dependency scripts for a database, downloads them, and runs them on the specified database.
 
    

## Inputs
| Parameter         | Is Required | Description           |
| ----------------- | ----------- | --------------------- |
| `db-server-name`  | true        | The server where the dependency files will be run. |
| `db-name`         | true        | The name of the database where the dependency files will run. |
| `dependency-list` | true        | A json string containing a list of objects with the name of the dependency package, the version, and the url where the package is stored. |

## Example

```yml
jobs:
  download-and-run-db-dependencies:
    runs-on: [self-hosted, windows-2019]
    steps:
      # For this example we'll retrieve packages from GitHub Packages 
      - name: Authenticate with GitHub Packages on Windows
        uses: im-open/authenticate-with-gh-packages-for-nuget@v1.0.1
        with:
          github-token: ${{ secrets.MY_GH_PACKAGES_ACCESS_TOKEN }} # Token has read:packages scope and is authorized for each of the orgs
          orgs: 'my-org'

      - name: Download and Run Dependencies
        uses: im-open/install-and-run-db-dependency-scripts@v1.0.0
        with:
          db-server-name: 'localhost,1433'
          db-name: 'LocalDb'
          dependency-list: '[{"version":"1.0.0","packageName":"dbo.Something","nugetUrl":"https://nuget.pkg.github.com/my-org/my-repo/dbo.Something.nupkg"},{"version":"1.2.0","packageName":"dbo.SomeOtherThing","nugetUrl":"https://nuget.pkg.github.com/my-org/my-repo/dbo.SomeOtherThing.nupkg"}]'
```


## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).
