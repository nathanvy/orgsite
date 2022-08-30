include secrets.mk

CXX=cat
CXXPRE=templates/prependix.html
CXXMID=templates/prependix2.html
CXXPOST=templates/appendix.html
TARGETS=staging/index.html staging/csharp-emacs.html staging/ubiquiti.html staging/raspi.html staging/orgsite.html staging/pro-cooking.html \
staging/postfix-dovecot-sni.html staging/hackrf.html staging/ipv6.html staging/sbcl-timers.html

default: $(TARGETS)

stage1/%.meta: content/%.meta
	mkdir -p stage1/
	cp $< $@

stage1/%.html: content/%.org
	mkdir -p stage1/
	pandoc $< -o $@

staging/%.html: stage1/%.meta stage1/%.html
	mkdir -p staging/
	$(CXX) $(CXXPRE) $(word 1, $^) $(CXXMID) $(word 2, $^) $(CXXPOST) > $@

clean:
	rm -rf staging/
	rm -rf stage1/

deploy:
	mkdir -p staging/css
	cp content/css/styles.css staging/css/
	mkdir -p staging/img
	cp content/img/*.png staging/img/
	cp content/img/*.jpg staging/img/
	mkdir -p staging/fonts
	cp content/fonts/amiga4ever.ttf staging/fonts/
	rsync -a --delete staging/ $(URI)
