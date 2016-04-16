Pod::Spec.new do |spec|
  spec.name         = 'AOAlertController'
  spec.version      = '1.1'
  spec.summary      = 'AOAlertController looks like a usual UIAlertController, but each action item, titles, fonts and colors can be customized.'
  spec.homepage     = 'https://github.com/0legAdamov/AOAlertController'
  spec.author       = { 'Oleg Adamov' => 'adamov.mailbox@yandex.ru' }
  spec.source       = { :git => 'https://github.com/0legAdamov/AOAlertController.git', :tag => "v#{spec.version}" }
  spec.source_files = 'Source/*.swift'
  spec.requires_arc = true
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.ios.deployment_target = "8.2"
end