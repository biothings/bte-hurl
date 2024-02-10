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
