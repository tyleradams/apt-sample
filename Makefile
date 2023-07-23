args = $(foreach a,$($(subst -,_,$1)_args),$(if $(value $a),$a="$($a)"))

PROJECT_NAME = hello-world
REPO_NAME = ppa:code-faster/test-1

clean :
	rm -rf target

install :
	prefix=/usr/local
	export prefix
	(cd src; prefix=/usr/local make install)

package :
	mkdir -p target/bin
	(cd src; make)
	tar czf target/$(PROJECT_NAME)_${version}.orig.tar.gz src --transform "s#src#$(PROJECT_NAME)-${version}#"
	(cd target; tar xf $(PROJECT_NAME)_${version}.orig.tar.gz;)
	cp -r debian target/$(PROJECT_NAME)-${version}/debian
	(cd target/$(PROJECT_NAME)-${version}; debuild -S -sa;)

publish:
	debsign -k ${DEBSIGN_KEY} ./target/$(PROJECT_NAME)_${version}_source.changes
	dput $(REPO_NAME) ./target/$(PROJECT_NAME)_${version}_source.changes
