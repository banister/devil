require 'rake/clean'
require 'rake/extensiontask'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'

DEVIL_VERSION = "0.1.3"

dlext = Config::CONFIG['DLEXT']

CLEAN.include("ext/**/*.#{dlext}", "ext/**/.log", "ext/**/.o", "ext/**/*~", "ext/**/*#*", "ext/**/.obj", "ext/**/.def", "ext/**/.pdb")
CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")

spec = Gem::Specification.new do |s|
    s.name = "devil"
    s.summary = "ruby bindings for devil cross platform image loading library"
    s.description = s.summary
    s.version = DEVIL_VERSION
    s.author = "Jaroslaw Tworek, John Mair (banisterfiend)"
    s.email = 'jrmair@gmail.com'
    s.date = Time.now.strftime '%Y-%m-%d'
    s.require_path = 'lib'
    s.homepage = "http://banisterfiend.wordpress.com"
    s.platform = Gem::Platform::RUBY
    s.extensions = FileList["ext/**/extconf.rb"]
    s.has_rdoc = true
    s.extra_rdoc_files = ["README"]
    s.rdoc_options << '--main' << 'README'
    s.files = ["Rakefile", "README", "LICENSE", "lib/devil.rb"] +
        FileList["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c", "test/test*.rb"].to_a

    # just have this here when cross compiling
    s.files += ["test/DevIL.dll", "test/ILU.dll"]
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
end

Rake::ExtensionTask.new('devil', spec)  do |ext|
    
    ext.config_script = 'extconf.rb' 
    ext.cross_compile = true                
    ext.cross_platform = 'i386-mswin32'
end

Rake::TestTask.new do |t|
    t.libs << "lib"
    t.test_files = FileList['test/test*.rb']
    t.verbose = true
end

Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/devil.rb")
end

