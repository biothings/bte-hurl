## Getting started

Install Hurl: https://hurl.dev/

## Usage

### Full tests

To run a full test on local:

```bash
./routine/full-test.sh
```

To run a full test on a specified environment, for example CI:

```bash
./routine/full-test.sh --ci
```

To run a slightly quicker test for some basic functionality confirmation:

```
./routine/full-test.sh quick
```

### Specific tests

Routine tests are designed to be given an environment and can't be run the same as a normal hurl file. You have to provide the variables-file:

```bash
hurl ./routine/metakg.hurl --variables-file env/ci --test
```

### Inspection

In order to inspect, remove `--test`. For example:

```bash
hurl ./routine/feature/creative/drug-treats-disease.hurl --variables-file env/local | jq -f analysis/node-frequency.jq
```

A fancier way to run hurl files is available via `./routine/inspect.sh`. Requires [jless](https://github.com/PaulJuliusMartinez/jless) and [gum](https://github.com/charmbracelet/gum).

This script allows you to run multiple files, either by argument or interactive selection, against different instances, and regardless of test success or failure (failures are reported) will allow you to both inspect the response in jless and save the response to a file. For more information, run the script with the `--help` flag.
