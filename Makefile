include secrets.mk

CXX=cat
CXXPRE=templates/prependix.html
CXXMID=templates/prependix2.html
CXXPOST=templates/appendix.html
TARGETS=staging/index.html staging/csharp-emacs.html staging/ubiquiti.html staging/raspi.html staging/orgsite.html staging/pro-cooking.html \
staging/postfix-dovecot-sni.html staging/hackrf.html staging/ipv6.html staging/sbcl-timers.html staging/multithreading.html \
staging/market1.html staging/contact.html staging/market2.html staging/busy.html

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
	cp content/favicon/* staging/
	mkdir -p staging/css
	cp content/css/*.css staging/css/
	mkdir -p staging/img
	cp content/img/*.png staging/img/
	cp content/img/*.jpg staging/img/
	mkdir -p staging/fonts
	cp content/fonts/*.ttf staging/fonts/
	mkdir -p staging/js
	cp content/js/*.js staging/js/
	rsync -a --delete staging/ $(URI)
