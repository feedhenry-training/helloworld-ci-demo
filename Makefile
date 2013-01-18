CLOUDTESTS = cloud_tests/*.js
NODEPATH = `pwd`/cloud:`pwd`/shared

all: deps test

test: cloudtest

cloudtest:
	env NODE_PATH=$(NODEPATH)  ./node_modules/.bin/mocha \
    --ui tdd \
		--reporter dot \
    --globals fh-nodeapp \
    --globals fh \
    --globals fhserver \
		--timeout 20000 \
		$(CLOUDTESTS)

deps:
	npm install . 

test-cov: lib-cov
	@CONNECT_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html

lib-cov:
	@jscoverage lib $@

.PHONY: test-cov test cloudtest all deps
