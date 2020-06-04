# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/mocha/all/mocha.rbi
#
# mocha-1.11.2

module Mocha
  def self.activate; end
  def self.configuration; end
  def self.configure; end
end
class Mocha::BacktraceFilter
  def filtered(backtrace); end
  def initialize(lib_directory = nil); end
end
class Mocha::Deprecation
  def self.messages; end
  def self.messages=(arg0); end
  def self.mode; end
  def self.mode=(arg0); end
  def self.warning(*messages); end
end
module Mocha::Debug
  def self.puts(message); end
end
module Mocha::Detection
end
module Mocha::Detection::TestUnit
  def self.testcase; end
  def self.version; end
end
module Mocha::Integration
  def self.activate; end
end
module Mocha::Integration::TestUnit
  def self.activate; end
end
module Mocha::Integration::TestUnit::Nothing
  def self.applicable_to?(_test_unit_version, _ruby_version = nil); end
  def self.description; end
  def self.included(_mod); end
end
class Mocha::Integration::AssertionCounter
  def increment; end
  def initialize(test_case); end
end
module Mocha::ParameterMatchers
  def Not(matcher); end
  def all_of(*matchers); end
  def any_of(*matchers); end
  def any_parameters; end
  def anything; end
  def equals(value); end
  def equivalent_uri(uri); end
  def has_entries(entries); end
  def has_entry(*options); end
  def has_key(key); end
  def has_value(value); end
  def includes(*items); end
  def instance_of(klass); end
  def is_a(klass); end
  def kind_of(klass); end
  def optionally(*matchers); end
  def regexp_matches(regexp); end
  def responds_with(message, result); end
  def yaml_equivalent(object); end
end
class Mocha::ParameterMatchers::Base
  def &(other); end
  def to_matcher; end
  def |(other); end
end
class Mocha::ParameterMatchers::Equals < Mocha::ParameterMatchers::Base
  def initialize(value); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
module Mocha::ParameterMatchers::InstanceMethods
  def to_matcher; end
end
class Object < BasicObject
  def __is_a__(arg0); end
  include Mocha::Inspect::ObjectMethods
  include Mocha::ObjectMethods
  include Mocha::ObjectMethods
  include Mocha::ParameterMatchers::InstanceMethods
end
class Mocha::ParameterMatchers::AllOf < Mocha::ParameterMatchers::Base
  def initialize(*matchers); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::AnyOf < Mocha::ParameterMatchers::Base
  def initialize(*matchers); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::AnyParameters < Mocha::ParameterMatchers::Base
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::Anything < Mocha::ParameterMatchers::Base
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::HasEntry < Mocha::ParameterMatchers::Base
  def initialize(key, value); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::HasEntries < Mocha::ParameterMatchers::Base
  def initialize(entries); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::HasKey < Mocha::ParameterMatchers::Base
  def initialize(key); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::HasValue < Mocha::ParameterMatchers::Base
  def initialize(value); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::Includes < Mocha::ParameterMatchers::Base
  def initialize(*items); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::InstanceOf < Mocha::ParameterMatchers::Base
  def initialize(klass); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::IsA < Mocha::ParameterMatchers::Base
  def initialize(klass); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::KindOf < Mocha::ParameterMatchers::Base
  def initialize(klass); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::Not < Mocha::ParameterMatchers::Base
  def initialize(matcher); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::Optionally < Mocha::ParameterMatchers::Base
  def initialize(*parameters); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::RegexpMatches < Mocha::ParameterMatchers::Base
  def initialize(regexp); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::RespondsWith < Mocha::ParameterMatchers::Base
  def initialize(message, result); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::YamlEquivalent < Mocha::ParameterMatchers::Base
  def initialize(object); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::ParameterMatchers::EquivalentUri < Mocha::ParameterMatchers::Base
  def explode(uri); end
  def initialize(uri); end
  def matches?(available_parameters); end
  def mocha_inspect; end
end
class Mocha::Central
  def initialize; end
  def stub(method); end
  def stubba_methods; end
  def stubba_methods=(arg0); end
  def unstub(method); end
  def unstub_all; end
end
class Mocha::Central::Null < Mocha::Central
  def initialize(&block); end
  def stub(*arg0); end
  def unstub(*arg0); end
end
class Mocha::MethodMatcher
  def expected_method_name; end
  def initialize(expected_method_name); end
  def match?(actual_method_name); end
  def mocha_inspect; end
end
module Mocha::Inspect
end
module Mocha::Inspect::ObjectMethods
  def mocha_inspect; end
end
module Mocha::Inspect::ArrayMethods
  def mocha_inspect; end
end
module Mocha::Inspect::HashMethods
  def mocha_inspect; end
end
module Mocha::Inspect::TimeMethods
  def mocha_inspect; end
end
module Mocha::Inspect::DateMethods
  def mocha_inspect; end
end
class Array
  include Mocha::Inspect::ArrayMethods
end
class Hash
  include Mocha::Inspect::HashMethods
end
class Time
  include Mocha::Inspect::TimeMethods
end
class Date
  include Mocha::Inspect::DateMethods
end
class Mocha::ParametersMatcher
  def initialize(expected_parameters = nil, &matching_block); end
  def match?(actual_parameters = nil); end
  def matchers; end
  def mocha_inspect; end
  def parameters_match?(actual_parameters); end
end
class Mocha::ExpectationError < Exception
end
class Mocha::SingleReturnValue
  def evaluate(invocation); end
  def initialize(value); end
end
class Mocha::ReturnValues
  def +(other); end
  def initialize(*values); end
  def next(invocation); end
  def self.build(*values); end
  def values; end
  def values=(arg0); end
end
class Mocha::ExceptionRaiser
  def evaluate(invocation); end
  def initialize(exception, message); end
end
class Mocha::Thrower
  def evaluate(invocation); end
  def initialize(tag, object = nil); end
end
class Mocha::YieldParameters
  def add(*parameter_groups); end
  def initialize; end
  def next_invocation; end
end
class Mocha::InStateOrderingConstraint
  def allows_invocation_now?; end
  def initialize(state_predicate); end
  def mocha_inspect; end
end
class Mocha::ChangeStateSideEffect
  def initialize(state); end
  def mocha_inspect; end
  def perform; end
end
class Mocha::Cardinality
  def <<(invocation); end
  def actual_invocations; end
  def allowed_any_number_of_times?; end
  def anticipated_times; end
  def infinite?(number); end
  def initialize(required, maximum); end
  def invocations_allowed?; end
  def invoked_times; end
  def maximum; end
  def needs_verifying?; end
  def required; end
  def satisfied?; end
  def self.at_least(count); end
  def self.at_most(count); end
  def self.exactly(count); end
  def self.times(range_or_count); end
  def times(number); end
  def used?; end
  def verified?; end
end
class Mocha::Configuration
  def display_matching_invocations_on_failure=(value); end
  def display_matching_invocations_on_failure?; end
  def initialize(options = nil); end
  def initialize_copy(other); end
  def merge(other); end
  def options; end
  def reinstate_undocumented_behaviour_from_v1_9=(value); end
  def reinstate_undocumented_behaviour_from_v1_9?; end
  def self.allow(action, &block); end
  def self.allow?(action); end
  def self.change_config(action, new_value, &block); end
  def self.configuration; end
  def self.override(temporary_options); end
  def self.prevent(action, &block); end
  def self.prevent?(action); end
  def self.reset_configuration; end
  def self.temporarily_change_config(action, new_value); end
  def self.warn_when(action, &block); end
  def self.warn_when?(action); end
  def stubbing_method_on_nil; end
  def stubbing_method_on_nil=(value); end
  def stubbing_method_on_non_mock_object; end
  def stubbing_method_on_non_mock_object=(value); end
  def stubbing_method_unnecessarily; end
  def stubbing_method_unnecessarily=(value); end
  def stubbing_non_existent_method; end
  def stubbing_non_existent_method=(value); end
  def stubbing_non_public_method; end
  def stubbing_non_public_method=(value); end
end
module Mocha::BlockMatchers
end
class Mocha::BlockMatchers::OptionalBlock
  def match?(_actual_block); end
  def mocha_inspect; end
end
class Mocha::BlockMatchers::BlockGiven
  def match?(actual_block); end
  def mocha_inspect; end
end
class Mocha::BlockMatchers::NoBlockGiven
  def match?(actual_block); end
  def mocha_inspect; end
end
class Mocha::Expectation
  def add_in_sequence_ordering_constraint(sequence); end
  def add_ordering_constraint(ordering_constraint); end
  def add_side_effect(side_effect); end
  def at_least(minimum_number_of_times); end
  def at_least_once; end
  def at_most(maximum_number_of_times); end
  def at_most_once; end
  def backtrace; end
  def in_correct_order?; end
  def in_sequence(sequence, *sequences); end
  def initialize(mock, expected_method_name, backtrace = nil); end
  def inspect; end
  def invocations_allowed?; end
  def invoke(invocation); end
  def match?(invocation); end
  def matches_method?(method_name); end
  def method_signature; end
  def mocha_inspect; end
  def multiple_yields(*parameter_groups); end
  def never; end
  def once; end
  def perform_side_effects; end
  def raises(exception = nil, message = nil); end
  def returns(*values); end
  def satisfied?; end
  def then(*parameters); end
  def throws(tag, object = nil); end
  def times(range); end
  def twice; end
  def used?; end
  def verified?(assertion_counter = nil); end
  def when(state_predicate); end
  def with(*expected_parameters, &matching_block); end
  def with_block_given; end
  def with_no_block_given; end
  def yields(*parameters); end
end
class Mocha::ExpectationList
  def +(other); end
  def add(expectation); end
  def any?; end
  def initialize(expectations = nil); end
  def length; end
  def match(invocation); end
  def match_allowing_invocation(invocation); end
  def matches_method?(method_name); end
  def matching_expectations(invocation); end
  def remove_all_matching_method(method_name); end
  def to_a; end
  def to_set; end
  def verified?(assertion_counter = nil); end
end
class Mocha::RaisedException
  def initialize(exception); end
  def mocha_inspect; end
end
class Mocha::ThrownObject
  def initialize(tag, value = nil); end
  def mocha_inspect; end
end
class Mocha::Invocation
  def arguments; end
  def block; end
  def call(yield_parameters = nil, return_values = nil); end
  def call_description; end
  def full_description; end
  def initialize(mock, method_name, *arguments, &block); end
  def method_name; end
  def raised(exception); end
  def result_description; end
  def returned(value); end
  def short_call_description; end
  def threw(tag, value); end
end
class Mocha::ImpersonatingName
  def initialize(object); end
  def mocha_inspect; end
end
class Mocha::ImpersonatingAnyInstanceName
  def initialize(klass); end
  def mocha_inspect; end
end
class Mocha::Name
  def initialize(name); end
  def mocha_inspect; end
end
class Mocha::DefaultName
  def initialize(mock); end
  def mocha_inspect; end
end
class Mocha::ObjectReceiver
  def initialize(object); end
  def mocks; end
end
class Mocha::AnyInstanceReceiver
  def initialize(klass); end
  def mocks; end
end
class Mocha::DefaultReceiver
  def initialize(mock); end
  def mocks; end
end
class Mocha::ArgumentIterator
  def each; end
  def initialize(argument); end
end
class Mocha::ExpectationErrorFactory
  def self.build(message = nil, backtrace = nil); end
  def self.exception_class; end
  def self.exception_class=(arg0); end
end
class Mocha::Mock
  def __expectations__; end
  def __expects__(method_name_or_hash, backtrace = nil); end
  def __expire__; end
  def __singleton_class__; end
  def __stubs__(method_name_or_hash, backtrace = nil); end
  def __verified__?(assertion_counter = nil); end
  def all_expectations; end
  def any_expectations?; end
  def check_expiry; end
  def check_responder_responds_to(symbol); end
  def ensure_method_not_already_defined(method_name); end
  def everything_stubbed; end
  def expects(method_name_or_hash, backtrace = nil); end
  def initialize(mockery, name = nil, receiver = nil); end
  def inspect; end
  def method_missing(symbol, *arguments, &block); end
  def mocha_inspect; end
  def quacks_like(responder); end
  def quacks_like_instance_of(responder_class); end
  def raise_unexpected_invocation_error(invocation, matching_expectation); end
  def respond_to_missing?(symbol, include_private = nil); end
  def responds_like(responder); end
  def responds_like_instance_of(responder_class); end
  def stub_everything; end
  def stubs(method_name_or_hash, backtrace = nil); end
  def unstub(*method_names); end
end
class Mocha::StateMachine
  def become(next_state_name); end
  def current_state; end
  def current_state=(arg0); end
  def initialize(name); end
  def is(state_name); end
  def is_not(state_name); end
  def mocha_inspect; end
  def name; end
  def starts_as(initial_state_name); end
end
class Mocha::StateMachine::State
  def activate; end
  def active?; end
  def initialize(state_machine, state); end
  def mocha_inspect; end
end
class Mocha::StateMachine::StatePredicate
  def active?; end
  def initialize(state_machine, state); end
  def mocha_inspect; end
end
class Mocha::Logger
  def initialize(io); end
  def warn(message); end
end
class Mocha::ErrorWithFilteredBacktrace < StandardError
  def initialize(message = nil, backtrace = nil); end
end
class Mocha::StubbingError < Mocha::ErrorWithFilteredBacktrace
end
class Mocha::NotInitializedError < Mocha::ErrorWithFilteredBacktrace
end
class Mocha::Mockery
  def add_mock(mock); end
  def add_state_machine(state_machine); end
  def check(action, description, signature_proc, backtrace = nil); end
  def expectations; end
  def logger; end
  def logger=(arg0); end
  def mocha_inspect; end
  def mock_impersonating(object); end
  def mock_impersonating_any_instance_of(klass); end
  def mocks; end
  def named_mock(name); end
  def new_state_machine(name); end
  def on_stubbing(object, method); end
  def on_stubbing_method_unnecessarily(expectation); end
  def reset; end
  def satisfied_expectations; end
  def self.instance; end
  def self.instances; end
  def self.setup; end
  def self.teardown; end
  def self.verify(*args); end
  def state_machines; end
  def stubba; end
  def teardown; end
  def unnamed_mock; end
  def unsatisfied_expectations; end
  def verify(assertion_counter = nil); end
end
class Mocha::Mockery::Null < Mocha::Mockery
  def add_mock(*arg0); end
  def add_state_machine(*arg0); end
  def raise_not_initialized_error; end
  def stubba; end
end
module Mocha::Hooks
  def mocha_setup; end
  def mocha_teardown; end
  def mocha_verify(assertion_counter = nil); end
end
class Mocha::Sequence
  def constrain_as_next_in_sequence(expectation); end
  def initialize(name); end
  def mocha_inspect; end
  def satisfied_to_index?(index); end
end
class Mocha::Sequence::InSequenceOrderingConstraint
  def allows_invocation_now?; end
  def initialize(sequence, index); end
  def mocha_inspect; end
end
class Mocha::StubbedMethod
  def ==(arg0); end
  def define_new_method; end
  def hide_original_method; end
  def initialize(stubbee, method_name); end
  def matches?(other); end
  def method_name; end
  def mock; end
  def remove_new_method; end
  def remove_original_method_from_stubbee; end
  def reset_mocha; end
  def restore_original_method; end
  def retain_original_visibility(method_owner); end
  def store_original_method; end
  def store_original_method_visibility; end
  def stub; end
  def stub_method_overwrites_original_method?; end
  def stub_method_owner; end
  def stubbee; end
  def to_s; end
  def unstub; end
  def use_prepended_module_for_stub_method; end
  def use_prepended_module_for_stub_method?; end
end
class Mocha::StubbedMethod::PrependedModule < Module
end
class Mocha::InstanceMethod < Mocha::StubbedMethod
  def method_body(method); end
  def mock_owner; end
  def original_method_owner; end
  def stubbee_method(method_name); end
end
module Mocha::ObjectMethods
  def _method(arg0); end
  def expects(expected_methods_vs_return_values); end
  def mocha(instantiate = nil); end
  def reset_mocha; end
  def stubba_class; end
  def stubba_method; end
  def stubba_object; end
  def stubs(stubbed_methods_vs_return_values); end
  def unstub(*method_names); end
end
class Mocha::AnyInstanceMethod < Mocha::StubbedMethod
  def method_body(method); end
  def mock_owner; end
  def original_method_owner; end
  def stubbee_method(method_name); end
end
module Mocha::ClassMethods
  def __method_exists__?(method, include_public_methods = nil); end
  def __method_visibility__(method, include_public_methods = nil); end
  def any_instance; end
end
class Mocha::ClassMethods::AnyInstance
  def initialize(klass); end
  def mocha(instantiate = nil); end
  def respond_to?(method); end
  def stubba_class; end
  def stubba_method; end
  def stubba_object; end
end
module Mocha::API
  def mock(*arguments); end
  def self.extended(mod); end
  def self.included(_mod); end
  def sequence(name); end
  def states(name); end
  def stub(*arguments); end
  def stub_everything(*arguments); end
  include Mocha::Hooks
  include Mocha::ParameterMatchers
end
module Mocha::Integration::MonkeyPatcher
  def self.apply(mod, run_method_patch); end
end
module Mocha::Integration::TestUnit::RubyVersion185AndBelow
  def self.applicable_to?(test_unit_version, ruby_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::TestUnit::RubyVersion185AndBelow::RunMethodPatch
  def run(result); end
end
module Mocha::Integration::TestUnit::RubyVersion186AndAbove
  def self.applicable_to?(test_unit_version, ruby_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::TestUnit::RubyVersion186AndAbove::RunMethodPatch
  def run(result); end
end
module Mocha::Integration::TestUnit::GemVersion200
  def self.applicable_to?(test_unit_version, _ruby_version = nil); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::TestUnit::GemVersion200::RunMethodPatch
  def run(result); end
end
module Mocha::Integration::TestUnit::GemVersion201To202
  def self.applicable_to?(test_unit_version, _ruby_version = nil); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::TestUnit::GemVersion201To202::RunMethodPatch
  def run(result); end
end
module Mocha::Integration::TestUnit::GemVersion203To220
  def self.applicable_to?(test_unit_version, _ruby_version = nil); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::TestUnit::GemVersion203To220::RunMethodPatch
  def run(result); end
end
module Mocha::Integration::TestUnit::GemVersion230To250
  def self.applicable_to?(test_unit_version, _ruby_version = nil); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::TestUnit::GemVersion230To250::RunMethodPatch
  def run(result); end
end
module Mocha::Integration::TestUnit::Adapter
  def handle_mocha_expectation_error(exception); end
  def self.applicable_to?(test_unit_version, _ruby_version = nil); end
  def self.description; end
  def self.included(mod); end
  include Mocha::API
end
class Class < Module
  include Mocha::ClassMethods
  include Mocha::ClassMethods
end
module Mocha::Detection::MiniTest
  def self.testcase; end
  def self.version; end
end
module Mocha::Integration::MiniTest
  def self.activate; end
  def self.translate(exception); end
end
module Mocha::Integration::MiniTest::Nothing
  def self.applicable_to?(_test_unit_version, _ruby_version = nil); end
  def self.description; end
  def self.included(_mod); end
end
module Mocha::Integration::MiniTest::Version13
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::MiniTest::Version13::RunMethodPatch
  def run(runner); end
end
module Mocha::Integration::MiniTest::Version140
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::MiniTest::Version140::RunMethodPatch
  def run(runner); end
end
module Mocha::Integration::MiniTest::Version141
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::MiniTest::Version141::RunMethodPatch
  def run(runner); end
end
module Mocha::Integration::MiniTest::Version142To172
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::MiniTest::Version142To172::RunMethodPatch
  def run(runner); end
end
module Mocha::Integration::MiniTest::Version200
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::MiniTest::Version200::RunMethodPatch
  def run(runner); end
end
module Mocha::Integration::MiniTest::Version201To222
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::MiniTest::Version201To222::RunMethodPatch
  def run(runner); end
end
module Mocha::Integration::MiniTest::Version230To2101
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::MiniTest::Version230To2101::RunMethodPatch
  def run(runner); end
end
module Mocha::Integration::MiniTest::Version2110To2111
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::MiniTest::Version2110To2111::RunMethodPatch
  def run(runner); end
end
module Mocha::Integration::MiniTest::Version2112To320
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(mod); end
end
module Mocha::Integration::MiniTest::Version2112To320::RunMethodPatch
  def run(runner); end
end
module Mocha::Integration::MiniTest::Adapter
  def after_teardown; end
  def before_setup; end
  def before_teardown; end
  def self.applicable_to?(mini_test_version); end
  def self.description; end
  def self.included(_mod); end
  include Mocha::API
end
class Minitest::Test < Minitest::Runnable
  include Mocha::Integration::MiniTest::Adapter
end
