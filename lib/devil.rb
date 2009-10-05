require 'rbconfig'

direc = File.dirname(__FILE__)
dlext = Config::CONFIG['DLEXT']
begin
    if RUBY_VERSION && RUBY_VERSION =~ /1.9/
        require "#{direc}/1.9/devil.#{dlext}"
    else
        require "#{direc}/1.8/devil.#{dlext}"
    end
rescue LoadError => e
    require "#{direc}/devil.#{dlext}"
end
