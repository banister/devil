require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'

# get the devil version
require './lib/devil/version'
dlext = Config::CONFIG['DLEXT']

CLEAN.include("ext/**/*.#{dlext}", "ext/**/.log", "ext/**/.o", "ext/**/*~", "ext/**/*#*", "ext/**/.obj", "ext/**/.def", "ext/**/.pdb")
CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")

spec = Gem::Specification.new do |s|
  s.name = "devil"
  s.summary = "Ruby bindings for DevIL cross platform image loading library"
  s.description = s.summary
  s.version = Devil::VERSION
  s.author = "Jaroslaw Tworek, John Mair (banisterfiend)"
  s.email = 'jrmair@gmail.com'
  s.date = Time.now.strftime '%Y-%m-%d'
  s.homepage = "http://banisterfiend.wordpress.com"

 # s.platform = 'i386-mswin32'
  s.platform = Gem::Platform::RUBY

  s.extensions = FileList["ext/**/extconf.rb"]

  s.has_rdoc = 'yard'
  s.extra_rdoc_files = ["README"]
  s.rdoc_options << '--main' << 'README'
  s.files = ["Rakefile", "README", "CHANGELOG", "LICENSE", "lib/devil.rb", "lib/devil/gosu.rb", "lib/devil/version.rb"] +
    FileList["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c", "test/test*.rb", "test/*.png", "test/*.jpg"].to_a

  #s.files += ["lib/1.8/devil.so", "lib/1.9/devil.so"]
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

task :compile => :clean


Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/devil.rb", "lib/devil/gosu.rb", "lib/devil/version.rb")
end

