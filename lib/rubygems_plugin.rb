# Copyright (C) 2012  Kouhei Sutou <kou@cozmixng.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program.  If not, see
# <http://www.gnu.org/licenses/>.

require "rubygems"

milk_command_line = [
  Gem.ruby,
  Gem.bin_path("milkode", "milk"),
]
sudo_user = ENV["SUDO_USER"]
if sudo_user
  milk_command_line.unshift("sudo", "-u", sudo_user, "-H")
  milkode_directory = File.expand_path("~#{sudo_user}/.milkode")
else
  milkode_directory = File.expand_path("~/.milkode")
end

ensure_init = lambda do
  unless File.exist?(milkode_directory)
    system(*(milk_command_line + ["init", "--default"]))
  end
end

Gem.post_install do |installer|
  ensure_init.call
  system(*(milk_command_line + ["add", installer.gem_dir]))
end

Gem.post_uninstall do |uninstaller|
  ensure_init.call
  system(*(milk_command_line + ["remove", uninstaller.spec.gem_dir]))
end
