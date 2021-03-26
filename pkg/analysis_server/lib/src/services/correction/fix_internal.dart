// Copyright (c) 2014, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:core';

import 'package:analysis_server/plugin/edit/fix/fix_core.dart';
import 'package:analysis_server/plugin/edit/fix/fix_dart.dart';
import 'package:analysis_server/src/services/correction/base_processor.dart';
import 'package:analysis_server/src/services/correction/dart/abstract_producer.dart';
import 'package:analysis_server/src/services/correction/dart/add_async.dart';
import 'package:analysis_server/src/services/correction/dart/add_await.dart';
import 'package:analysis_server/src/services/correction/dart/add_const.dart';
import 'package:analysis_server/src/services/correction/dart/add_diagnostic_property_reference.dart';
import 'package:analysis_server/src/services/correction/dart/add_explicit_cast.dart';
import 'package:analysis_server/src/services/correction/dart/add_field_formal_parameters.dart';
import 'package:analysis_server/src/services/correction/dart/add_late.dart';
import 'package:analysis_server/src/services/correction/dart/add_missing_enum_case_clauses.dart';
import 'package:analysis_server/src/services/correction/dart/add_missing_parameter.dart';
import 'package:analysis_server/src/services/correction/dart/add_missing_parameter_named.dart';
import 'package:analysis_server/src/services/correction/dart/add_missing_required_argument.dart';
import 'package:analysis_server/src/services/correction/dart/add_ne_null.dart';
import 'package:analysis_server/src/services/correction/dart/add_null_check.dart';
import 'package:analysis_server/src/services/correction/dart/add_override.dart';
import 'package:analysis_server/src/services/correction/dart/add_required.dart';
import 'package:analysis_server/src/services/correction/dart/add_required_keyword.dart';
import 'package:analysis_server/src/services/correction/dart/add_return_type.dart';
import 'package:analysis_server/src/services/correction/dart/add_static.dart';
import 'package:analysis_server/src/services/correction/dart/add_super_constructor_invocation.dart';
import 'package:analysis_server/src/services/correction/dart/add_type_annotation.dart';
import 'package:analysis_server/src/services/correction/dart/change_argument_name.dart';
import 'package:analysis_server/src/services/correction/dart/change_to.dart';
import 'package:analysis_server/src/services/correction/dart/change_to_nearest_precise_value.dart';
import 'package:analysis_server/src/services/correction/dart/change_to_static_access.dart';
import 'package:analysis_server/src/services/correction/dart/change_type_annotation.dart';
import 'package:analysis_server/src/services/correction/dart/convert_add_all_to_spread.dart';
import 'package:analysis_server/src/services/correction/dart/convert_conditional_expression_to_if_element.dart';
import 'package:analysis_server/src/services/correction/dart/convert_documentation_into_line.dart';
import 'package:analysis_server/src/services/correction/dart/convert_flutter_child.dart';
import 'package:analysis_server/src/services/correction/dart/convert_flutter_children.dart';
import 'package:analysis_server/src/services/correction/dart/convert_into_is_not.dart';
import 'package:analysis_server/src/services/correction/dart/convert_map_from_iterable_to_for_literal.dart';
import 'package:analysis_server/src/services/correction/dart/convert_quotes.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_contains.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_expression_function_body.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_generic_function_syntax.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_if_null.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_int_literal.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_list_literal.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_map_literal.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_named_arguments.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_null_aware.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_null_aware_spread.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_on_type.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_package_import.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_relative_import.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_set_literal.dart';
import 'package:analysis_server/src/services/correction/dart/convert_to_where_type.dart';
import 'package:analysis_server/src/services/correction/dart/create_class.dart';
import 'package:analysis_server/src/services/correction/dart/create_constructor.dart';
import 'package:analysis_server/src/services/correction/dart/create_constructor_for_final_fields.dart';
import 'package:analysis_server/src/services/correction/dart/create_constructor_super.dart';
import 'package:analysis_server/src/services/correction/dart/create_field.dart';
import 'package:analysis_server/src/services/correction/dart/create_file.dart';
import 'package:analysis_server/src/services/correction/dart/create_function.dart';
import 'package:analysis_server/src/services/correction/dart/create_getter.dart';
import 'package:analysis_server/src/services/correction/dart/create_local_variable.dart';
import 'package:analysis_server/src/services/correction/dart/create_method.dart';
import 'package:analysis_server/src/services/correction/dart/create_method_or_function.dart';
import 'package:analysis_server/src/services/correction/dart/create_missing_overrides.dart';
import 'package:analysis_server/src/services/correction/dart/create_mixin.dart';
import 'package:analysis_server/src/services/correction/dart/create_no_such_method.dart';
import 'package:analysis_server/src/services/correction/dart/create_setter.dart';
import 'package:analysis_server/src/services/correction/dart/data_driven.dart';
import 'package:analysis_server/src/services/correction/dart/extend_class_for_mixin.dart';
import 'package:analysis_server/src/services/correction/dart/import_library.dart';
import 'package:analysis_server/src/services/correction/dart/inline_invocation.dart';
import 'package:analysis_server/src/services/correction/dart/inline_typedef.dart';
import 'package:analysis_server/src/services/correction/dart/insert_semicolon.dart';
import 'package:analysis_server/src/services/correction/dart/make_class_abstract.dart';
import 'package:analysis_server/src/services/correction/dart/make_field_not_final.dart';
import 'package:analysis_server/src/services/correction/dart/make_final.dart';
import 'package:analysis_server/src/services/correction/dart/make_return_type_nullable.dart';
import 'package:analysis_server/src/services/correction/dart/make_variable_not_final.dart';
import 'package:analysis_server/src/services/correction/dart/make_variable_nullable.dart';
import 'package:analysis_server/src/services/correction/dart/move_type_arguments_to_class.dart';
import 'package:analysis_server/src/services/correction/dart/organize_imports.dart';
import 'package:analysis_server/src/services/correction/dart/qualify_reference.dart';
import 'package:analysis_server/src/services/correction/dart/remove_annotation.dart';
import 'package:analysis_server/src/services/correction/dart/remove_argument.dart';
import 'package:analysis_server/src/services/correction/dart/remove_await.dart';
import 'package:analysis_server/src/services/correction/dart/remove_comparison.dart';
import 'package:analysis_server/src/services/correction/dart/remove_const.dart';
import 'package:analysis_server/src/services/correction/dart/remove_dead_code.dart';
import 'package:analysis_server/src/services/correction/dart/remove_dead_if_null.dart';
import 'package:analysis_server/src/services/correction/dart/remove_duplicate_case.dart';
import 'package:analysis_server/src/services/correction/dart/remove_empty_catch.dart';
import 'package:analysis_server/src/services/correction/dart/remove_empty_constructor_body.dart';
import 'package:analysis_server/src/services/correction/dart/remove_empty_else.dart';
import 'package:analysis_server/src/services/correction/dart/remove_empty_statement.dart';
import 'package:analysis_server/src/services/correction/dart/remove_if_null_operator.dart';
import 'package:analysis_server/src/services/correction/dart/remove_initializer.dart';
import 'package:analysis_server/src/services/correction/dart/remove_interpolation_braces.dart';
import 'package:analysis_server/src/services/correction/dart/remove_method_declaration.dart';
import 'package:analysis_server/src/services/correction/dart/remove_name_from_combinator.dart';
import 'package:analysis_server/src/services/correction/dart/remove_non_null_assertion.dart';
import 'package:analysis_server/src/services/correction/dart/remove_operator.dart';
import 'package:analysis_server/src/services/correction/dart/remove_parameters_in_getter_declaration.dart';
import 'package:analysis_server/src/services/correction/dart/remove_parentheses_in_getter_invocation.dart';
import 'package:analysis_server/src/services/correction/dart/remove_question_mark.dart';
import 'package:analysis_server/src/services/correction/dart/remove_this_expression.dart';
import 'package:analysis_server/src/services/correction/dart/remove_type_annotation.dart';
import 'package:analysis_server/src/services/correction/dart/remove_type_arguments.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unnecessary_cast.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unnecessary_new.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unnecessary_parentheses.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unnecessary_string_interpolation.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unused.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unused_catch_clause.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unused_catch_stack.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unused_import.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unused_label.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unused_local_variable.dart';
import 'package:analysis_server/src/services/correction/dart/remove_unused_parameter.dart';
import 'package:analysis_server/src/services/correction/dart/rename_to_camel_case.dart';
import 'package:analysis_server/src/services/correction/dart/replace_boolean_with_bool.dart';
import 'package:analysis_server/src/services/correction/dart/replace_cascade_with_dot.dart';
import 'package:analysis_server/src/services/correction/dart/replace_colon_with_equals.dart';
import 'package:analysis_server/src/services/correction/dart/replace_final_with_const.dart';
import 'package:analysis_server/src/services/correction/dart/replace_final_with_var.dart';
import 'package:analysis_server/src/services/correction/dart/replace_new_with_const.dart';
import 'package:analysis_server/src/services/correction/dart/replace_null_with_closure.dart';
import 'package:analysis_server/src/services/correction/dart/replace_return_type_future.dart';
import 'package:analysis_server/src/services/correction/dart/replace_var_with_dynamic.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_brackets.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_conditional_assignment.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_eight_digit_hex.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_extension_name.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_filled.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_identifier.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_interpolation.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_is_empty.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_not_null_aware.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_null_aware.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_tear_off.dart';
import 'package:analysis_server/src/services/correction/dart/replace_with_var.dart';
import 'package:analysis_server/src/services/correction/dart/sort_child_property_last.dart';
import 'package:analysis_server/src/services/correction/dart/update_sdk_constraints.dart';
import 'package:analysis_server/src/services/correction/dart/use_const.dart';
import 'package:analysis_server/src/services/correction/dart/use_curly_braces.dart';
import 'package:analysis_server/src/services/correction/dart/use_effective_integer_division.dart';
import 'package:analysis_server/src/services/correction/dart/use_eq_eq_null.dart';
import 'package:analysis_server/src/services/correction/dart/use_is_not_empty.dart';
import 'package:analysis_server/src/services/correction/dart/use_not_eq_null.dart';
import 'package:analysis_server/src/services/correction/dart/use_rethrow.dart';
import 'package:analysis_server/src/services/correction/dart/wrap_in_future.dart';
import 'package:analysis_server/src/services/correction/dart/wrap_in_text.dart';
import 'package:analysis_server/src/services/correction/fix.dart';
import 'package:analysis_server/src/services/correction/util.dart';
import 'package:analysis_server/src/services/linter/lint_names.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/src/error/codes.dart';
import 'package:analyzer/src/generated/java_core.dart';
import 'package:analyzer/src/generated/parser.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_workspace.dart';
import 'package:analyzer_plugin/utilities/change_builder/conflicting_edit_exception.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart' hide FixContributor;
import 'package:meta/meta.dart';

/// A function that can be executed to create a multi-correction producer.
typedef MultiProducerGenerator = MultiCorrectionProducer Function();

/// A function that can be executed to create a correction producer.
typedef ProducerGenerator = CorrectionProducer Function();

/// A fix contributor that provides the default set of fixes for Dart files.
class DartFixContributor implements FixContributor {
  @override
  Future<List<Fix>> computeFixes(DartFixContext context) async {
    try {
      var processor = FixProcessor(context);
      var fixes = await processor.compute();
      var fixInFileProcessor = FixInFileProcessor(context);
      var fixInFileFixes = await fixInFileProcessor.compute();
      fixes.addAll(fixInFileFixes);
      return fixes;
    } on CancelCorrectionException {
      return const <Fix>[];
    }
  }
}

/// Computer for Dart "fix all in file" fixes.
class FixInFileProcessor {
  final DartFixContext context;
  FixInFileProcessor(this.context);

  Future<List<Fix>> compute() async {
    var error = context.error;
    var errors = context.resolveResult.errors
        .where((e) => error.errorCode.name == e.errorCode.name);
    if (errors.length < 2) {
      return const <Fix>[];
    }

    var instrumentationService = context.instrumentationService;
    var workspace = context.workspace;
    var resolveResult = context.resolveResult;

    var generators = _getGenerators(
        error.errorCode,
        CorrectionProducerContext(
          dartFixContext: context,
          diagnostic: error,
          resolvedResult: resolveResult,
          selectionOffset: context.error.offset,
          selectionLength: context.error.length,
          workspace: workspace,
        ));

    var fixes = <Fix>[];
    for (var generator in generators) {
      var fixState = FixState(workspace);
      for (var error in errors) {
        var fixContext = DartFixContextImpl(
          instrumentationService,
          workspace,
          resolveResult,
          error,
          (name) => [],
        );
        await _fixError(fixContext, fixState, generator(), error);
      }
      var sourceChange = fixState.builder.sourceChange;
      if (sourceChange.edits.isNotEmpty) {
        var fixKind = fixState.fixKind;
        if (fixState.fixCount > 1) {
          sourceChange.message = fixKind.message;
          fixes.add(Fix(fixKind, sourceChange));
        }
      }
    }
    return fixes;
  }

  Future<void> _fixError(DartFixContext fixContext, FixState fixState,
      CorrectionProducer producer, AnalysisError diagnostic) async {
    var context = CorrectionProducerContext(
      applyingBulkFixes: true,
      dartFixContext: fixContext,
      diagnostic: diagnostic,
      resolvedResult: fixContext.resolveResult,
      selectionOffset: diagnostic.offset,
      selectionLength: diagnostic.length,
      workspace: fixContext.workspace,
    );

    var setupSuccess = context.setupCompute();
    if (!setupSuccess) {
      return;
    }

    producer.configure(context);

    try {
      var localBuilder = fixState.builder.copy();
      await producer.compute(localBuilder);
      fixState.builder = localBuilder;
      // todo (pq): consider discarding the change if the producer's fixKind
      // doesn't match a previously cached one.
      fixState.fixKind = producer.multiFixKind;
      fixState.fixCount++;
    } on ConflictingEditException {
      // If a conflicting edit was added in [compute], then the [localBuilder]
      // is discarded and we revert to the previous state of the builder.
    }
  }

  List<ProducerGenerator> _getGenerators(
      ErrorCode errorCode, CorrectionProducerContext context) {
    var producers = <ProducerGenerator>[];
    if (errorCode is LintCode) {
      var fixInfos = FixProcessor.lintProducerMap[errorCode.name] ?? [];
      for (var fixInfo in fixInfos) {
        if (fixInfo.canBeAppliedToFile) {
          producers.addAll(fixInfo.generators);
        }
      }
    } else {
      var fixInfos = FixProcessor.nonLintProducerMap2[errorCode] ?? [];
      for (var fixInfo in fixInfos) {
        if (fixInfo.canBeAppliedToFile) {
          producers.addAll(fixInfo.generators);
        }
      }
      // todo (pq): consider support for multiGenerators
    }
    return producers;
  }
}

class FixInfo {
  final bool canBeAppliedToFile;
  final bool canBeBulkApplied;
  final List<ProducerGenerator> generators;
  const FixInfo({
    @required this.canBeAppliedToFile,
    @required this.canBeBulkApplied,
    @required this.generators,
  });
}

/// The computer for Dart fixes.
class FixProcessor extends BaseProcessor {
  /// todo (pq): to replace nonLintProducerMap.
  static const Map<ErrorCode, List<FixInfo>> nonLintProducerMap2 = {
    CompileTimeErrorCode.NON_BOOL_CONDITION: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: false,
        generators: [
          AddNeNull.newInstance,
        ],
      ),
    ],
    HintCode.TYPE_CHECK_IS_NOT_NULL: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: false,
        generators: [
          UseNotEqNull.newInstance,
        ],
      ),
    ],
    HintCode.TYPE_CHECK_IS_NULL: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: false,
        generators: [
          UseEqEqNull.newInstance,
        ],
      ),
    ],
    CompileTimeErrorCode.UNDEFINED_CLASS_BOOLEAN: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: false,
        generators: [
          ReplaceBooleanWithBool.newInstance,
        ],
      ),
    ],
    HintCode.UNNECESSARY_CAST: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: false,
        generators: [
          RemoveUnnecessaryCast.newInstance,
        ],
      ),
    ],
    HintCode.UNUSED_IMPORT: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: false,
        generators: [
          RemoveUnusedImport.newInstance,
        ],
      ),
    ],
    StaticWarningCode.UNNECESSARY_NON_NULL_ASSERTION: [
      FixInfo(
        // todo (pq): consider adding
        canBeAppliedToFile: false,
        canBeBulkApplied: true,
        generators: [
          RemoveNonNullAssertion.newInstance,
        ],
      ),
    ],
  };

  /// A map from the names of lint rules to a list of generators used to create
  /// the correction producers used to build fixes for those diagnostics. The
  /// generators used for non-lint diagnostics are in the [nonLintProducerMap].
  static const Map<String, List<FixInfo>> lintProducerMap = {
    LintNames.always_declare_return_types: [
      FixInfo(
        // todo (pq): enable when tested
        canBeAppliedToFile: false,
        // not currently supported; TODO(pq): consider adding
        canBeBulkApplied: false,
        generators: [
          AddReturnType.newInstance,
        ],
      )
    ],
    LintNames.always_require_non_null_named_parameters: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          AddRequired.newInstance,
        ],
      )
    ],
    LintNames.always_specify_types: [
      FixInfo(
        // todo (pq): enable when tested
        canBeAppliedToFile: false,
        // not currently supported; TODO(pq): consider adding
        canBeBulkApplied: false,
        generators: [
          AddTypeAnnotation.newInstance,
        ],
      )
    ],
    LintNames.annotate_overrides: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          AddOverride.newInstance,
        ],
      )
    ],
    LintNames.avoid_annotating_with_dynamic: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveTypeAnnotation.newInstance,
        ],
      )
    ],
    LintNames.avoid_empty_else: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveEmptyElse.newInstance,
        ],
      )
    ],
    LintNames.avoid_init_to_null: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveInitializer.newInstance,
        ],
      )
    ],
    LintNames.avoid_private_typedef_functions: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          InlineTypedef.newInstance,
        ],
      )
    ],
    LintNames.avoid_redundant_argument_values: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveArgument.newInstance,
        ],
      )
    ],
    LintNames.avoid_relative_lib_imports: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToPackageImport.newInstance,
        ],
      )
    ],
    LintNames.avoid_return_types_on_setters: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveTypeAnnotation.newInstance,
        ],
      )
    ],
    LintNames.avoid_returning_null_for_future: [
      FixInfo(
        canBeAppliedToFile: false,
        // not currently supported; TODO(pq): consider adding
        canBeBulkApplied: false,
        generators: [
          AddAsync.newInstance,
          WrapInFuture.newInstance,
        ],
      )
    ],
    LintNames.avoid_single_cascade_in_expression_statements: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          // TODO(brianwilkerson) This fix should be applied to some non-lint
          //  diagnostics and should also be available as an assist.
          ReplaceCascadeWithDot.newInstance,
        ],
      )
    ],
    LintNames.avoid_types_as_parameter_names: [
      FixInfo(
        canBeAppliedToFile: false,
        canBeBulkApplied: false,
        generators: [
          ConvertToOnType.newInstance,
        ],
      )
    ],
    LintNames.avoid_types_on_closure_parameters: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ReplaceWithIdentifier.newInstance,
          RemoveTypeAnnotation.newInstance,
        ],
      )
    ],
    LintNames.avoid_unused_constructor_parameters: [
      FixInfo(
        // todo (pq): enable when tested
        canBeAppliedToFile: false,
        canBeBulkApplied: false,
        generators: [
          RemoveUnusedParameter.newInstance,
        ],
      )
    ],
    LintNames.await_only_futures: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveAwait.newInstance,
        ],
      )
    ],
    LintNames.curly_braces_in_flow_control_structures: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          UseCurlyBraces.newInstance,
        ],
      )
    ],
    LintNames.diagnostic_describe_all_properties: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          AddDiagnosticPropertyReference.newInstance,
        ],
      )
    ],
    LintNames.directives_ordering: [
      FixInfo(
        canBeAppliedToFile: false, // Fix will sort all directives.
        canBeBulkApplied: false,
        generators: [
          OrganizeImports.newInstance,
        ],
      )
    ],
    LintNames.empty_catches: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveEmptyCatch.newInstance,
        ],
      )
    ],
    LintNames.empty_constructor_bodies: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveEmptyConstructorBody.newInstance,
        ],
      )
    ],
    LintNames.empty_statements: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveEmptyStatement.newInstance,
          ReplaceWithBrackets.newInstance,
        ],
      )
    ],
    LintNames.hash_and_equals: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          CreateMethod.equalsOrHashCode,
        ],
      )
    ],
    LintNames.no_duplicate_case_values: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveDuplicateCase.newInstance,
        ],
      )
    ],
    LintNames.non_constant_identifier_names: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RenameToCamelCase.newInstance,
        ],
      )
    ],
    LintNames.null_closures: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ReplaceNullWithClosure.newInstance,
        ],
      )
    ],
    LintNames.omit_local_variable_types: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ReplaceWithVar.newInstance,
        ],
      )
    ],
    LintNames.prefer_adjacent_string_concatenation: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveOperator.newInstance,
        ],
      )
    ],
    LintNames.prefer_collection_literals: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToListLiteral.newInstance,
          ConvertToMapLiteral.newInstance,
          ConvertToSetLiteral.newInstance,
        ],
      )
    ],
    LintNames.prefer_conditional_assignment: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ReplaceWithConditionalAssignment.newInstance,
        ],
      )
    ],
    LintNames.prefer_const_constructors: [
      FixInfo(
        canBeAppliedToFile: false,
        // Can produce results incompatible w/ `unnecessary_const`
        canBeBulkApplied: false,
        generators: [
          AddConst.newInstance,
          ReplaceNewWithConst.newInstance,
        ],
      )
    ],
    LintNames.prefer_const_constructors_in_immutables: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          AddConst.newInstance,
        ],
      )
    ],
    LintNames.prefer_const_declarations: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ReplaceFinalWithConst.newInstance,
        ],
      )
    ],
    LintNames.prefer_contains: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToContains.newInstance,
        ],
      )
    ],
    LintNames.prefer_equal_for_default_values: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ReplaceColonWithEquals.newInstance,
        ],
      )
    ],
    LintNames.prefer_expression_function_bodies: [
      FixInfo(
        // todo (pq): enable when tested
        canBeAppliedToFile: false,
        // not currently supported; TODO(pq): consider adding
        canBeBulkApplied: false,
        generators: [
          ConvertToExpressionFunctionBody.newInstance,
        ],
      )
    ],
    LintNames.prefer_final_fields: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          MakeFinal.newInstance,
        ],
      )
    ],
    LintNames.prefer_final_in_for_each: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          MakeFinal.newInstance,
        ],
      )
    ],
    LintNames.prefer_final_locals: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          MakeFinal.newInstance,
        ],
      )
    ],
    LintNames.prefer_for_elements_to_map_fromIterable: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertMapFromIterableToForLiteral.newInstance,
        ],
      )
    ],
    LintNames.prefer_generic_function_type_aliases: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToGenericFunctionSyntax.newInstance,
        ],
      )
    ],
    LintNames.prefer_if_elements_to_conditional_expressions: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertConditionalExpressionToIfElement.newInstance,
        ],
      )
    ],
    LintNames.prefer_is_empty: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ReplaceWithIsEmpty.newInstance,
        ],
      )
    ],
    LintNames.prefer_is_not_empty: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          UseIsNotEmpty.newInstance,
        ],
      )
    ],
    LintNames.prefer_if_null_operators: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToIfNull.newInstance,
        ],
      )
    ],
    LintNames.prefer_inlined_adds: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertAddAllToSpread.newInstance,
          InlineInvocation.newInstance,
        ],
      )
    ],
    LintNames.prefer_int_literals: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToIntLiteral.newInstance,
        ],
      )
    ],
    LintNames.prefer_interpolation_to_compose_strings: [
      FixInfo(
        // todo (pq): enable when tested
        canBeAppliedToFile: false,
        // not currently supported; TODO(pq): consider adding
        canBeBulkApplied: false,
        generators: [
          ReplaceWithInterpolation.newInstance,
        ],
      )
    ],
    // todo (pq): note this is not in lintProducerMap
    LintNames.prefer_is_not_operator: [
      FixInfo(
        // todo (pq): consider enabling
        canBeAppliedToFile: false,
        canBeBulkApplied: true,
        generators: [
          ConvertIntoIsNot.newInstance,
        ],
      )
    ],
    LintNames.prefer_iterable_whereType: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToWhereType.newInstance,
        ],
      )
    ],
    LintNames.prefer_null_aware_operators: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToNullAware.newInstance,
        ],
      )
    ],
    LintNames.prefer_relative_imports: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToRelativeImport.newInstance,
        ],
      )
    ],
    LintNames.prefer_single_quotes: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToSingleQuotes.newInstance,
        ],
      )
    ],
    LintNames.prefer_spread_collections: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertAddAllToSpread.newInstance,
        ],
      )
    ],
    LintNames.slash_for_doc_comments: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertDocumentationIntoLine.newInstance,
        ],
      )
    ],
    LintNames.sort_child_properties_last: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          SortChildPropertyLast.newInstance,
        ],
      )
    ],
    LintNames.type_annotate_public_apis: [
      FixInfo(
        // todo (pq): enable when tested
        canBeAppliedToFile: false,
        // not currently supported; TODO(pq): consider adding
        canBeBulkApplied: false,
        generators: [
          AddTypeAnnotation.newInstance,
        ],
      )
    ],
    LintNames.type_init_formals: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveTypeAnnotation.newInstance,
        ],
      )
    ],
    LintNames.unawaited_futures: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          AddAwait.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_brace_in_string_interps: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveInterpolationBraces.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_const: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveUnnecessaryConst.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_final: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ReplaceFinalWithVar.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_lambdas: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ReplaceWithTearOff.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_new: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveUnnecessaryNew.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_null_in_if_null_operators: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveIfNullOperator.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_nullable_for_final_variable_declarations: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveQuestionMark.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_overrides: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveMethodDeclaration.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_parenthesis: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveUnnecessaryParentheses.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_string_interpolations: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveUnnecessaryStringInterpolation.newInstance,
        ],
      )
    ],
    LintNames.unnecessary_this: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          RemoveThisExpression.newInstance,
        ],
      )
    ],
    LintNames.use_full_hex_values_for_flutter_colors: [
      FixInfo(
        // todo (pq): enable when tested
        canBeAppliedToFile: false,
        // not currently supported; TODO(pq): consider adding
        canBeBulkApplied: false,
        generators: [
          ReplaceWithEightDigitHex.newInstance,
        ],
      )
    ],
    LintNames.use_function_type_syntax_for_parameters: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          ConvertToGenericFunctionSyntax.newInstance,
        ],
      )
    ],
    LintNames.use_rethrow_when_possible: [
      FixInfo(
        canBeAppliedToFile: true,
        canBeBulkApplied: true,
        generators: [
          UseRethrow.newInstance,
        ],
      )
    ],
  };

  /// A map from error codes to a list of generators used to create multiple
  /// correction producers used to build fixes for those diagnostics. The
  /// generators used for lint rules are in the [lintMultiProducerMap].
  static const Map<ErrorCode, List<MultiProducerGenerator>>
      nonLintMultiProducerMap = {
    CompileTimeErrorCode.CAST_TO_NON_TYPE: [
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.CONST_WITH_NON_TYPE: [
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.EXTENDS_NON_CLASS: [
      DataDriven.newInstance,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.EXTRA_POSITIONAL_ARGUMENTS: [
      AddMissingParameter.newInstance,
      DataDriven.newInstance,
    ],
    CompileTimeErrorCode.EXTRA_POSITIONAL_ARGUMENTS_COULD_BE_NAMED: [
      AddMissingParameter.newInstance,
      DataDriven.newInstance,
    ],
    CompileTimeErrorCode.IMPLEMENTS_NON_CLASS: [
      DataDriven.newInstance,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.INVALID_ANNOTATION: [
      ImportLibrary.forTopLevelVariable,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.INVALID_OVERRIDE: [
      DataDriven.newInstance,
    ],
    CompileTimeErrorCode.MIXIN_OF_NON_CLASS: [
      DataDriven.newInstance,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.NEW_WITH_NON_TYPE: [
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.NEW_WITH_UNDEFINED_CONSTRUCTOR_DEFAULT: [
      DataDriven.newInstance,
    ],
    CompileTimeErrorCode.NO_DEFAULT_SUPER_CONSTRUCTOR_EXPLICIT: [
      AddSuperConstructorInvocation.newInstance,
    ],
    CompileTimeErrorCode.NO_DEFAULT_SUPER_CONSTRUCTOR_IMPLICIT: [
      AddSuperConstructorInvocation.newInstance,
      CreateConstructorSuper.newInstance,
    ],
    CompileTimeErrorCode.NON_TYPE_IN_CATCH_CLAUSE: [
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.NON_TYPE_AS_TYPE_ARGUMENT: [
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.NOT_A_TYPE: [
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.NOT_ENOUGH_POSITIONAL_ARGUMENTS: [
      DataDriven.newInstance,
    ],
    CompileTimeErrorCode.TYPE_TEST_WITH_UNDEFINED_NAME: [
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.UNDEFINED_ANNOTATION: [
      ImportLibrary.forTopLevelVariable,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.UNDEFINED_CLASS: [
      DataDriven.newInstance,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.UNDEFINED_CONSTRUCTOR_IN_INITIALIZER_DEFAULT: [
      AddSuperConstructorInvocation.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_FUNCTION: [
      DataDriven.newInstance,
      ImportLibrary.forExtension,
      ImportLibrary.forFunction,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.UNDEFINED_GETTER: [
      DataDriven.newInstance,
      ImportLibrary.forTopLevelVariable,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.UNDEFINED_IDENTIFIER: [
      DataDriven.newInstance,
      ImportLibrary.forExtension,
      ImportLibrary.forFunction,
      ImportLibrary.forTopLevelVariable,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.UNDEFINED_METHOD: [
      DataDriven.newInstance,
      ImportLibrary.forFunction,
      ImportLibrary.forType,
    ],
    CompileTimeErrorCode.UNDEFINED_NAMED_PARAMETER: [
      ChangeArgumentName.newInstance,
      DataDriven.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_SETTER: [
      DataDriven.newInstance,
      // TODO(brianwilkerson) Support ImportLibrary
    ],
    CompileTimeErrorCode.WRONG_NUMBER_OF_TYPE_ARGUMENTS: [
      DataDriven.newInstance,
    ],
    CompileTimeErrorCode.WRONG_NUMBER_OF_TYPE_ARGUMENTS_CONSTRUCTOR: [
      DataDriven.newInstance,
    ],
    CompileTimeErrorCode.WRONG_NUMBER_OF_TYPE_ARGUMENTS_EXTENSION: [
      DataDriven.newInstance,
    ],
    CompileTimeErrorCode.WRONG_NUMBER_OF_TYPE_ARGUMENTS_METHOD: [
      DataDriven.newInstance,
    ],
    HintCode.DEPRECATED_MEMBER_USE: [
      DataDriven.newInstance,
    ],
    HintCode.DEPRECATED_MEMBER_USE_WITH_MESSAGE: [
      DataDriven.newInstance,
    ],
    HintCode.OVERRIDE_ON_NON_OVERRIDING_METHOD: [
      DataDriven.newInstance,
    ],
    HintCode.SDK_VERSION_ASYNC_EXPORTED_FROM_CORE: [
      ImportLibrary.dartAsync,
    ],
  };

  /// A map from error codes to a list of generators used to create the
  /// correction producers used to build fixes for those diagnostics. The
  /// generators used for lint rules are in the [lintProducerMap].
  static const Map<ErrorCode, List<ProducerGenerator>> nonLintProducerMap = {
    CompileTimeErrorCode.ASSIGNMENT_TO_FINAL: [
      MakeFieldNotFinal.newInstance,
      AddLate.newInstance,
    ],
    CompileTimeErrorCode.ASSIGNMENT_TO_FINAL_LOCAL: [
      MakeVariableNotFinal.newInstance,
    ],
    CompileTimeErrorCode.ARGUMENT_TYPE_NOT_ASSIGNABLE: [
      AddNullCheck.newInstance,
      WrapInText.newInstance,
    ],
    CompileTimeErrorCode.ASYNC_FOR_IN_WRONG_CONTEXT: [
      AddAsync.newInstance,
    ],
    CompileTimeErrorCode.AWAIT_IN_WRONG_CONTEXT: [
      AddAsync.newInstance,
    ],
    CompileTimeErrorCode.BODY_MIGHT_COMPLETE_NORMALLY: [
      AddAsync.missingReturn,
    ],
    CompileTimeErrorCode.CAST_TO_NON_TYPE: [
      ChangeTo.classOrMixin,
      CreateClass.newInstance,
      CreateMixin.newInstance,
    ],
    CompileTimeErrorCode.CONCRETE_CLASS_WITH_ABSTRACT_MEMBER: [
      CreateMissingOverrides.newInstance,
      CreateNoSuchMethod.newInstance,
      MakeClassAbstract.newInstance,
    ],
    CompileTimeErrorCode.CONST_INITIALIZED_WITH_NON_CONSTANT_VALUE: [
      UseConst.newInstance,
    ],
    CompileTimeErrorCode.CONST_INSTANCE_FIELD: [
      AddStatic.newInstance,
    ],
    CompileTimeErrorCode.CONST_WITH_NON_CONST: [
      RemoveConst.newInstance,
    ],
    CompileTimeErrorCode.DEFAULT_LIST_CONSTRUCTOR: [
      ReplaceWithFilled.newInstance,
    ],
    CompileTimeErrorCode.CONST_WITH_NON_TYPE: [
      ChangeTo.classOrMixin,
    ],
    CompileTimeErrorCode.EXTENDS_NON_CLASS: [
      ChangeTo.classOrMixin,
      CreateClass.newInstance,
    ],
    CompileTimeErrorCode.EXTENSION_OVERRIDE_ACCESS_TO_STATIC_MEMBER: [
      ReplaceWithExtensionName.newInstance,
    ],
    CompileTimeErrorCode.EXTRA_POSITIONAL_ARGUMENTS: [
      CreateConstructor.newInstance,
    ],
    CompileTimeErrorCode.EXTRA_POSITIONAL_ARGUMENTS_COULD_BE_NAMED: [
      CreateConstructor.newInstance,
      ConvertToNamedArguments.newInstance,
    ],
    CompileTimeErrorCode.FINAL_NOT_INITIALIZED: [
      AddLate.newInstance,
      CreateConstructorForFinalFields.newInstance,
    ],
    CompileTimeErrorCode.FINAL_NOT_INITIALIZED_CONSTRUCTOR_1: [
      AddFieldFormalParameters.newInstance,
    ],
    CompileTimeErrorCode.FINAL_NOT_INITIALIZED_CONSTRUCTOR_2: [
      AddFieldFormalParameters.newInstance,
    ],
    CompileTimeErrorCode.FINAL_NOT_INITIALIZED_CONSTRUCTOR_3_PLUS: [
      AddFieldFormalParameters.newInstance,
    ],
    CompileTimeErrorCode.ILLEGAL_ASYNC_RETURN_TYPE: [
      ReplaceReturnTypeFuture.newInstance,
    ],
    CompileTimeErrorCode.IMPLEMENTS_NON_CLASS: [
      ChangeTo.classOrMixin,
      CreateClass.newInstance,
    ],
    CompileTimeErrorCode.INITIALIZING_FORMAL_FOR_NON_EXISTENT_FIELD: [
      CreateField.newInstance,
    ],
    CompileTimeErrorCode.INSTANCE_ACCESS_TO_STATIC_MEMBER: [
      ChangeToStaticAccess.newInstance,
    ],
    CompileTimeErrorCode.INTEGER_LITERAL_IMPRECISE_AS_DOUBLE: [
      ChangeToNearestPreciseValue.newInstance,
    ],
    CompileTimeErrorCode.INVALID_ANNOTATION: [
      ChangeTo.annotation,
      CreateClass.newInstance,
    ],
    CompileTimeErrorCode.INVALID_ASSIGNMENT: [
      AddExplicitCast.newInstance,
      AddNullCheck.newInstance,
      ChangeTypeAnnotation.newInstance,
      MakeVariableNullable.newInstance,
    ],
    CompileTimeErrorCode.INVOCATION_OF_NON_FUNCTION_EXPRESSION: [
      RemoveParenthesesInGetterInvocation.newInstance,
    ],
    CompileTimeErrorCode.MISSING_DEFAULT_VALUE_FOR_PARAMETER: [
      AddRequiredKeyword.newInstance,
      MakeVariableNullable.newInstance,
    ],
    CompileTimeErrorCode.MISSING_REQUIRED_ARGUMENT: [
      AddMissingRequiredArgument.newInstance,
    ],
    CompileTimeErrorCode.MIXIN_APPLICATION_NOT_IMPLEMENTED_INTERFACE: [
      ExtendClassForMixin.newInstance,
    ],
    CompileTimeErrorCode.MIXIN_OF_NON_CLASS: [
      ChangeTo.classOrMixin,
      CreateClass.newInstance,
    ],
    CompileTimeErrorCode.NEW_WITH_NON_TYPE: [
      ChangeTo.classOrMixin,
    ],
    CompileTimeErrorCode.NEW_WITH_UNDEFINED_CONSTRUCTOR: [
      CreateConstructor.newInstance,
    ],
    CompileTimeErrorCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_FIVE_PLUS:
        [
      CreateMissingOverrides.newInstance,
      CreateNoSuchMethod.newInstance,
      MakeClassAbstract.newInstance,
    ],
    CompileTimeErrorCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_FOUR: [
      CreateMissingOverrides.newInstance,
      CreateNoSuchMethod.newInstance,
      MakeClassAbstract.newInstance,
    ],
    CompileTimeErrorCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_ONE: [
      CreateMissingOverrides.newInstance,
      CreateNoSuchMethod.newInstance,
      MakeClassAbstract.newInstance,
    ],
    CompileTimeErrorCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_THREE: [
      CreateMissingOverrides.newInstance,
      CreateNoSuchMethod.newInstance,
      MakeClassAbstract.newInstance,
    ],
    CompileTimeErrorCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_TWO: [
      CreateMissingOverrides.newInstance,
      CreateNoSuchMethod.newInstance,
      MakeClassAbstract.newInstance,
    ],
    CompileTimeErrorCode.NON_BOOL_CONDITION: [
      AddNeNull.newInstance,
    ],
    CompileTimeErrorCode.NON_TYPE_AS_TYPE_ARGUMENT: [
      CreateClass.newInstance,
      CreateMixin.newInstance,
    ],
    CompileTimeErrorCode.NOT_A_TYPE: [
      ChangeTo.classOrMixin,
      CreateClass.newInstance,
      CreateMixin.newInstance,
    ],
    CompileTimeErrorCode.NOT_INITIALIZED_NON_NULLABLE_INSTANCE_FIELD: [
      AddLate.newInstance,
    ],
    CompileTimeErrorCode.NULLABLE_TYPE_IN_EXTENDS_CLAUSE: [
      RemoveQuestionMark.newInstance,
    ],
    CompileTimeErrorCode.NULLABLE_TYPE_IN_IMPLEMENTS_CLAUSE: [
      RemoveQuestionMark.newInstance,
    ],
    CompileTimeErrorCode.NULLABLE_TYPE_IN_ON_CLAUSE: [
      RemoveQuestionMark.newInstance,
    ],
    CompileTimeErrorCode.NULLABLE_TYPE_IN_WITH_CLAUSE: [
      RemoveQuestionMark.newInstance,
    ],
    CompileTimeErrorCode.RETURN_OF_INVALID_TYPE_FROM_FUNCTION: [
      MakeReturnTypeNullable.newInstance,
    ],
    CompileTimeErrorCode.RETURN_OF_INVALID_TYPE_FROM_METHOD: [
      MakeReturnTypeNullable.newInstance,
    ],
    CompileTimeErrorCode.TYPE_TEST_WITH_UNDEFINED_NAME: [
      ChangeTo.classOrMixin,
      CreateClass.newInstance,
      CreateMixin.newInstance,
    ],
    CompileTimeErrorCode.UNCHECKED_INVOCATION_OF_NULLABLE_VALUE: [
      AddNullCheck.newInstance,
    ],
    CompileTimeErrorCode.UNCHECKED_METHOD_INVOCATION_OF_NULLABLE_VALUE: [
      AddNullCheck.newInstance,
    ],
    CompileTimeErrorCode.UNCHECKED_OPERATOR_INVOCATION_OF_NULLABLE_VALUE: [
      AddNullCheck.newInstance,
    ],
    CompileTimeErrorCode.UNCHECKED_PROPERTY_ACCESS_OF_NULLABLE_VALUE: [
      AddNullCheck.newInstance,
    ],
    CompileTimeErrorCode.UNCHECKED_USE_OF_NULLABLE_VALUE: [
      AddNullCheck.newInstance,
    ],
    CompileTimeErrorCode.UNCHECKED_USE_OF_NULLABLE_VALUE_AS_CONDITION: [
      AddNullCheck.newInstance,
    ],
    CompileTimeErrorCode.UNCHECKED_USE_OF_NULLABLE_VALUE_AS_ITERATOR: [
      AddNullCheck.newInstance,
    ],
    CompileTimeErrorCode.UNCHECKED_USE_OF_NULLABLE_VALUE_IN_SPREAD: [
      AddNullCheck.newInstance,
      ConvertToNullAwareSpread.newInstance,
    ],
    CompileTimeErrorCode.UNCHECKED_USE_OF_NULLABLE_VALUE_IN_YIELD_EACH: [
      AddNullCheck.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_ANNOTATION: [
      ChangeTo.annotation,
      CreateClass.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_CLASS: [
      ChangeTo.classOrMixin,
      CreateClass.newInstance,
      CreateMixin.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_CLASS_BOOLEAN: [
      ReplaceBooleanWithBool.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_EXTENSION_GETTER: [
      ChangeTo.getterOrSetter,
      CreateGetter.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_EXTENSION_METHOD: [
      ChangeTo.method,
      CreateMethod.method,
    ],
    CompileTimeErrorCode.UNDEFINED_EXTENSION_SETTER: [
      ChangeTo.getterOrSetter,
      CreateSetter.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_FUNCTION: [
      ChangeTo.function,
      CreateClass.newInstance,
      CreateFunction.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_GETTER: [
      ChangeTo.getterOrSetter,
      CreateClass.newInstance,
      CreateField.newInstance,
      CreateGetter.newInstance,
      CreateLocalVariable.newInstance,
      CreateMethodOrFunction.newInstance,
      CreateMixin.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_IDENTIFIER: [
      ChangeTo.getterOrSetter,
      CreateClass.newInstance,
      CreateField.newInstance,
      CreateGetter.newInstance,
      CreateLocalVariable.newInstance,
      CreateMethodOrFunction.newInstance,
      CreateMixin.newInstance,
      CreateSetter.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_IDENTIFIER_AWAIT: [
      AddAsync.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_METHOD: [
      ChangeTo.method,
      CreateClass.newInstance,
      CreateFunction.newInstance,
      CreateMethod.method,
    ],
    CompileTimeErrorCode.UNDEFINED_NAMED_PARAMETER: [
      AddMissingParameterNamed.newInstance,
      ConvertFlutterChild.newInstance,
      ConvertFlutterChildren.newInstance,
    ],
    CompileTimeErrorCode.UNDEFINED_SETTER: [
      ChangeTo.getterOrSetter,
      CreateField.newInstance,
      CreateSetter.newInstance,
    ],
    CompileTimeErrorCode.UNQUALIFIED_REFERENCE_TO_NON_LOCAL_STATIC_MEMBER: [
      // TODO(brianwilkerson) Consider adding fixes to create a field, getter,
      //  method or setter. The existing _addFix methods would need to be
      //  updated so that only the appropriate subset is generated.
      QualifyReference.newInstance,
    ],
    CompileTimeErrorCode
        .UNQUALIFIED_REFERENCE_TO_STATIC_MEMBER_OF_EXTENDED_TYPE: [
      // TODO(brianwilkerson) Consider adding fixes to create a field, getter,
      //  method or setter. The existing producers would need to be updated so
      //  that only the appropriate subset is generated.
      QualifyReference.newInstance,
    ],
    CompileTimeErrorCode.URI_DOES_NOT_EXIST: [
      CreateFile.newInstance,
    ],
    CompileTimeErrorCode.WRONG_NUMBER_OF_TYPE_ARGUMENTS_CONSTRUCTOR: [
      MoveTypeArgumentsToClass.newInstance,
      RemoveTypeArguments.newInstance,
    ],
    CompileTimeErrorCode.YIELD_OF_INVALID_TYPE: [
      MakeReturnTypeNullable.newInstance,
    ],

    HintCode.CAN_BE_NULL_AFTER_NULL_AWARE: [
      ReplaceWithNullAware.newInstance,
    ],
    HintCode.DEAD_CODE: [
      RemoveDeadCode.newInstance,
    ],
    HintCode.DEAD_CODE_CATCH_FOLLOWING_CATCH: [
      // TODO(brianwilkerson) Add a fix to move the unreachable catch clause to
      //  a place where it can be reached (when possible).
      RemoveDeadCode.newInstance,
    ],
    HintCode.DEAD_CODE_ON_CATCH_SUBTYPE: [
      // TODO(brianwilkerson) Add a fix to move the unreachable catch clause to
      //  a place where it can be reached (when possible).
      RemoveDeadCode.newInstance,
    ],
    HintCode.DIVISION_OPTIMIZATION: [
      UseEffectiveIntegerDivision.newInstance,
    ],
    HintCode.DUPLICATE_HIDDEN_NAME: [
      RemoveNameFromCombinator.newInstance,
    ],
    HintCode.DUPLICATE_IMPORT: [
      RemoveUnusedImport.newInstance,
    ],
    HintCode.DUPLICATE_SHOWN_NAME: [
      RemoveNameFromCombinator.newInstance,
    ],
    // TODO(brianwilkerson) Add a fix to convert the path to a package: import.
//    HintCode.FILE_IMPORT_OUTSIDE_LIB_REFERENCES_FILE_INSIDE: [],
    HintCode.INVALID_FACTORY_ANNOTATION: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.INVALID_IMMUTABLE_ANNOTATION: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.INVALID_LITERAL_ANNOTATION: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.INVALID_REQUIRED_NAMED_PARAM: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.INVALID_REQUIRED_OPTIONAL_POSITIONAL_PARAM: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.INVALID_REQUIRED_POSITIONAL_PARAM: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.INVALID_SEALED_ANNOTATION: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.MISSING_REQUIRED_PARAM: [
      AddMissingRequiredArgument.newInstance,
    ],
    HintCode.MISSING_REQUIRED_PARAM_WITH_DETAILS: [
      AddMissingRequiredArgument.newInstance,
    ],
    HintCode.MISSING_RETURN: [
      AddAsync.missingReturn,
    ],
    HintCode.NULLABLE_TYPE_IN_CATCH_CLAUSE: [
      RemoveQuestionMark.newInstance,
    ],
    HintCode.OVERRIDE_ON_NON_OVERRIDING_FIELD: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.OVERRIDE_ON_NON_OVERRIDING_GETTER: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.OVERRIDE_ON_NON_OVERRIDING_METHOD: [
      RemoveAnnotation.newInstance,
    ],
    HintCode.OVERRIDE_ON_NON_OVERRIDING_SETTER: [
      RemoveAnnotation.newInstance,
    ],
    // TODO(brianwilkerson) Add a fix to normalize the path.
//    HintCode.PACKAGE_IMPORT_CONTAINS_DOT_DOT: [],
    HintCode.SDK_VERSION_AS_EXPRESSION_IN_CONST_CONTEXT: [
      UpdateSdkConstraints.version_2_2_2,
    ],
    HintCode.SDK_VERSION_ASYNC_EXPORTED_FROM_CORE: [
      UpdateSdkConstraints.version_2_1_0,
    ],
    HintCode.SDK_VERSION_BOOL_OPERATOR_IN_CONST_CONTEXT: [
      UpdateSdkConstraints.version_2_2_2,
    ],
    HintCode.SDK_VERSION_EQ_EQ_OPERATOR_IN_CONST_CONTEXT: [
      UpdateSdkConstraints.version_2_2_2,
    ],
    HintCode.SDK_VERSION_EXTENSION_METHODS: [
      UpdateSdkConstraints.version_2_6_0,
    ],
    HintCode.SDK_VERSION_GT_GT_GT_OPERATOR: [
      UpdateSdkConstraints.version_2_2_2,
    ],
    HintCode.SDK_VERSION_IS_EXPRESSION_IN_CONST_CONTEXT: [
      UpdateSdkConstraints.version_2_2_2,
    ],
    HintCode.SDK_VERSION_SET_LITERAL: [
      UpdateSdkConstraints.version_2_2_0,
    ],
    HintCode.SDK_VERSION_UI_AS_CODE: [
      UpdateSdkConstraints.version_2_2_2,
    ],
    HintCode.TYPE_CHECK_IS_NOT_NULL: [
      UseNotEqNull.newInstance,
    ],
    HintCode.TYPE_CHECK_IS_NULL: [
      UseEqEqNull.newInstance,
    ],
    HintCode.UNDEFINED_HIDDEN_NAME: [
      RemoveNameFromCombinator.newInstance,
    ],
    HintCode.UNDEFINED_SHOWN_NAME: [
      RemoveNameFromCombinator.newInstance,
    ],
    HintCode.UNNECESSARY_CAST: [
      RemoveUnnecessaryCast.newInstance,
    ],
//    HintCode.UNNECESSARY_NO_SUCH_METHOD: [
// TODO(brianwilkerson) Add a fix to remove the method.
//    ],
    HintCode.UNNECESSARY_NULL_COMPARISON_FALSE: [
      RemoveComparison.newInstance,
    ],
    HintCode.UNNECESSARY_NULL_COMPARISON_TRUE: [
      RemoveComparison.newInstance,
    ],
//    HintCode.UNNECESSARY_TYPE_CHECK_FALSE: [
// TODO(brianwilkerson) Add a fix to remove the type check.
//    ],
//    HintCode.UNNECESSARY_TYPE_CHECK_TRUE: [
// TODO(brianwilkerson) Add a fix to remove the type check.
//    ],
    HintCode.UNUSED_CATCH_CLAUSE: [
      RemoveUnusedCatchClause.newInstance,
    ],
    HintCode.UNUSED_CATCH_STACK: [
      RemoveUnusedCatchStack.newInstance,
    ],
    HintCode.UNUSED_ELEMENT: [
      RemoveUnusedElement.newInstance,
    ],
    HintCode.UNUSED_FIELD: [
      RemoveUnusedField.newInstance,
    ],
    HintCode.UNUSED_IMPORT: [
      RemoveUnusedImport.newInstance,
    ],
    HintCode.UNUSED_LABEL: [
      RemoveUnusedLabel.newInstance,
    ],
    HintCode.UNUSED_LOCAL_VARIABLE: [
      RemoveUnusedLocalVariable.newInstance,
    ],
    HintCode.UNUSED_SHOWN_NAME: [
      RemoveNameFromCombinator.newInstance,
    ],
    ParserErrorCode.EXPECTED_TOKEN: [
      InsertSemicolon.newInstance,
    ],
    ParserErrorCode.GETTER_WITH_PARAMETERS: [
      RemoveParametersInGetterDeclaration.newInstance,
    ],
    ParserErrorCode.MISSING_CONST_FINAL_VAR_OR_TYPE: [
      AddTypeAnnotation.newInstance,
    ],
    ParserErrorCode.VAR_AS_TYPE_NAME: [
      ReplaceVarWithDynamic.newInstance,
    ],
    StaticWarningCode.DEAD_NULL_AWARE_EXPRESSION: [
      RemoveDeadIfNull.newInstance,
    ],
    StaticWarningCode.INVALID_NULL_AWARE_OPERATOR: [
      ReplaceWithNotNullAware.newInstance,
    ],
    StaticWarningCode.INVALID_NULL_AWARE_OPERATOR_AFTER_SHORT_CIRCUIT: [
      ReplaceWithNotNullAware.newInstance,
    ],
    StaticWarningCode.MISSING_ENUM_CONSTANT_IN_SWITCH: [
      AddMissingEnumCaseClauses.newInstance,
    ],
    StaticWarningCode.UNNECESSARY_NON_NULL_ASSERTION: [
      RemoveNonNullAssertion.newInstance,
    ],
  };

  final DartFixContext fixContext;

  final List<Fix> fixes = <Fix>[];

  FixProcessor(this.fixContext)
      : super(
          resolvedResult: fixContext.resolveResult,
          workspace: fixContext.workspace,
        );

  Future<List<Fix>> compute() async {
    await _addFromProducers();
    return fixes;
  }

  Future<Fix> computeFix() async {
    await _addFromProducers();
    fixes.sort(Fix.SORT_BY_RELEVANCE);
    return fixes.isNotEmpty ? fixes.first : null;
  }

  void _addFixFromBuilder(ChangeBuilder builder, FixKind kind,
      {List<Object> args, bool importsOnly = false}) {
    if (builder == null) return;
    var change = builder.sourceChange;
    if (change.edits.isEmpty && !importsOnly) {
      return;
    }
    change.id = kind.id;
    change.message = formatList(kind.message, args);
    fixes.add(Fix(kind, change));
  }

  Future<void> _addFromProducers() async {
    var error = fixContext.error;
    var context = CorrectionProducerContext(
      dartFixContext: fixContext,
      diagnostic: error,
      resolvedResult: resolvedResult,
      selectionOffset: fixContext.error.offset,
      selectionLength: fixContext.error.length,
      workspace: workspace,
    );

    var setupSuccess = context.setupCompute();
    if (!setupSuccess) {
      return;
    }

    Future<void> compute(CorrectionProducer producer) async {
      producer.configure(context);
      var builder = ChangeBuilder(
          workspace: context.workspace, eol: context.utils.endOfLine);
      try {
        await producer.compute(builder);
        _addFixFromBuilder(builder, producer.fixKind,
            args: producer.fixArguments);
      } on ConflictingEditException catch (exception, stackTrace) {
        // Handle the exception by (a) not adding a fix based on the producer
        // and (b) logging the exception.
        fixContext.instrumentationService.logException(exception, stackTrace);
      }
    }

    var errorCode = error.errorCode;
    if (errorCode is LintCode) {
      var fixes = lintProducerMap[errorCode.name] ?? [];
      for (var fix in fixes) {
        for (var generator in fix.generators) {
          await compute(generator());
        }
      }
    } else {
      var generators = nonLintProducerMap[errorCode];
      if (generators != null) {
        for (var generator in generators) {
          await compute(generator());
        }
      }
      var multiGenerators = nonLintMultiProducerMap[errorCode];
      if (multiGenerators != null) {
        for (var multiGenerator in multiGenerators) {
          var multiProducer = multiGenerator();
          multiProducer.configure(context);
          for (var producer in multiProducer.producers) {
            await compute(producer);
          }
        }
      }
    }
  }
}

/// State associated with producing fix-all-in-file fixes.
class FixState {
  ChangeBuilder builder;
  FixKind fixKind;
  int fixCount = 0;
  FixState(ChangeWorkspace workspace)
      : builder = ChangeBuilder(workspace: workspace);
}
