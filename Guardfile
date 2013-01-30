# A sample Guardfile
# More info at https://github.com/guard/guard#readme
notification :growl

guard :rspec do
  watch('spec/spec_helper.rb') { "spec" }
end

guard 'spork' do
  watch('lib/codebreaker.rb')
end
