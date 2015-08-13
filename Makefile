.PHONY: test pep8 clean coverage doc check-venv check-reqs check-venv

# clean out potentially stale pyc files
clean:
	@find . -name "*.pyc" -exec rm {} \;

# check that virtualenv is enabled
check-venv:
ifndef VIRTUAL_ENV
	$(error VIRTUAL_ENV is undefined, try "workon" command)
endif

# check that requirements have been installed
check-reqs: check-venv
	-piplint requirements.txt

# Install pip requirements.txt file
reqs: check-venv
	pip install -r requirements.txt

PEP8_OPTS=--repeat --exclude=static,south_migrations,migrations,js,doc --show-source

pep8:
	pep8 $(PEP8_OPTS) .

#
# flake8
#

FLAKE8_OPTS = --max-complexity 10 --exclude 'south_migrations, migrations'
flake8: check-venv
	flake8 $(FLAKE8_OPTS) . | tee flake8.log

#
# unit tests
#

test: check-venv clean
	./manage.py test

#
# code coverage
#

COVERAGE_INCLUDE='cmsplugin_tabs/*'

coverage: check-reqs
	coverage erase
	-coverage run --include=$(COVERAGE_INCLUDE) ./manage.py test
	coverage report
	coverage html
	@echo "See ./htmlcov/index.html for coverage report"
