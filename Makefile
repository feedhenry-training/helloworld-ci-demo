CLOUDTESTS = cloud_tests/*.js
NODEPATH = `pwd`/cloud:`pwd`/shared
NODEPATH_COVERAGE = `pwd`/cloud-cov:`pwd`/shared
REPORTER = dot

all: clean deps test-cov

test: cloudtest
test-cov: cloudtest-cov

cloudtest:
	@env NODE_PATH=$(NODEPATH) ./node_modules/.bin/mocha \
    --ui tdd \
		--reporter $(REPORTER) \
    --globals fh-nodeapp \
    --globals fh \
    --globals fhserver \
		--timeout 20000 \
		$(CLOUDTESTS)

deps:
	cd cloud; npm install .
	npm install . 

cloudtest-cov: cloud-cov
	@$(MAKE) test REPORTER=html-cov NODEPATH=$(NODEPATH_COVERAGE) > cloudcoverage.html

cloud-cov:
	@jscoverage --no-instrument=node_modules cloud $@

clean: 
	rm -rf cloud-cov
	rm -rf node_modules

.PHONY: cloud-cov test cloudtest all deps
