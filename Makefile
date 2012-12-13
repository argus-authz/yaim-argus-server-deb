#
# Copyright (c) Members of the EGEE Collaboration. 2004-2010.
# See http://www.eu-egee.org/partners/ for details on the copyright holders. 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Debian packaging
#
name = yaim-argus-server
version = 2.3.0
release = 1

dist_url = http://argus-authz.github.com/$(name)/distrib/$(name)-$(version).tar.gz

git_url = https://github.com/argus-authz/$(name).git
#git_branch = $(version)
git_branch = EMI-3

debbuild_dir = $(CURDIR)/debbuild

all: deb-src

clean:
	@echo "Cleaning..."
	rm -rf $(debbuild_dir) *.deb $(name)*

pre_debbuild:
	@echo "Prepare for Debian building in $(debbuild_dir)"
	mkdir -p $(debbuild_dir)
	test -f $(debbuild_dir)/$(name)_$(version).orig.tar.gz || wget -O $(debbuild_dir)/$(name)_$(version).orig.tar.gz $(dist_url)
	tar -C $(debbuild_dir) -xzf $(debbuild_dir)/$(name)_$(version).orig.tar.gz
	cp -r debian $(debbuild_dir)/$(name)-$(version)

deb-src: pre_debbuild
	@echo "Building Debian source package in $(debbuild_dir)"
	cd $(debbuild_dir) && dpkg-source -b $(name)-$(version)
	find $(debbuild_dir) -maxdepth 1 -type f -exec cp '{}' . \;

deb: pre_debbuild
	@echo "Building Debian package in $(debbuild_dir)"
	cd $(debbuild_dir)/$(name)-$(version) && debuild -us -uc 
	find $(debbuild_dir) -maxdepth 1 -name "*.deb" -exec cp '{}' . \;

git_source:
	@echo "Checkout source [$(git_branch)] from $(git_url)"
	git clone $(git_url)
	(cd $(name) && git checkout $(git_branch))
	(cd $(name) && make dist)
	mkdir -p $(debbuild_dir)
	cp $(name)/$(name)-$(version).tar.gz $(debbuild_dir)/$(name)_$(version).orig.tar.gz
