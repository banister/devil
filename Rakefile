require 'rake/clean'

if RUBY_PLATFORM !~ /win32/
    require 'rake/extensiontask'
end

require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'

DEVIL_VERSION = "0.1.8.5"

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

    if RUBY_PLATFORM =~ /win32/
        s.platform = Gem::Platform::CURRENT
    else
        s.platform = Gem::Platform::RUBY
    end

    if RUBY_PLATFORM !~ /win32/
        s.extensions = FileList["ext/**/extconf.rb"]
    end
    
    s.has_rdoc = true
    s.extra_rdoc_files = ["README"]
    s.rdoc_options << '--main' << 'README'
    s.files = ["Rakefile", "README", "CHANGELOG", "LICENSE", "lib/devil.rb", "lib/devil/gosu.rb"] +
        FileList["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c", "test/test*.rb", "test/*.png", "test/*.jpg"].to_a

    if RUBY_PLATFORM =~ /win32/
        s.files += ["lib/1.8/devil.so", "lib/1.9/devil.so"]
    end

end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
end

task :compile => :clean

if RUBY_PLATFORM !~ /win32/
    Rake::ExtensionTask.new('devil', spec)  do |ext|
        ext.config_script = 'extconf.rb' 
        ext.cross_compile = true                
        ext.cross_platform = 'i386-mswin32'
    end
end

Rake::TestTask.new do |t|
    t.libs << "lib"
    t.test_files = FileList['test/test*.rb']
    t.verbose = true
end

Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/devil.rb", "lib/devil/gosu.rb")
end

