## Usage

### Makefile editing

Edit the first few lines of ``Makefile``:

```
# Change at least these lines:
##############################
ORG ?= pcdshub
REPO ?= typhos
BRANCH ?= master
IMPORT_NAME ?= $(REPO)
PIP_EXTRAS ?= PyQt5 pip .
##############################
```

Run ``make`` to build the image and run tests.

### Command-line

```bash
make REPO=lightpath
```
