Pod::Spec.new do |s|
  s.name = 'Container'
  s.version = '0.0.1'
  s.summary = 'Container lib.'
  s.description = <<-DESC
  Container is a Dependency injection.
                   DESC

  s.license = { type: 'MIT', file: 'LICENSE' }
  s.authors = { 'Amine Bensalah' => 'amine.bensalah@outlook.com' }

  s.ios.deployment_target = '12.0'

  s.requires_arc = true
  s.source = { git: 'https://github.com/amine2233/Container.git', tag: s.version.to_s }
  s.swift_version = '5.0'
  s.homepage     = 'https://github.com/amine2233/Container.git'

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => s.swift_version
  }

  s.module_name = s.name
  s.source_files = 'Sources/Container/**/*.{swift}'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/ContainerTests/**/*.{swift}'
  end

end
