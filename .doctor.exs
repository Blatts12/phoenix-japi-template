%Doctor.Config{
  ignore_modules: [Inspect.Scroll.Accounts.User, ScrollWeb],
  ignore_paths: [~r(^test*)],
  min_module_doc_coverage: 0,
  min_module_spec_coverage: 100,
  min_overall_doc_coverage: 0,
  min_overall_spec_coverage: 100,
  moduledoc_required: true,
  exception_moduledoc_required: true,
  raise: false,
  reporter: Doctor.Reporters.Full,
  struct_type_spec_required: true,
  umbrella: false,
  failed: false
}
