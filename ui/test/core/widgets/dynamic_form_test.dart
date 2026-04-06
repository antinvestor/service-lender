import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lender_ui/core/widgets/dynamic_form.dart';
import 'package:lender_ui/sdk/src/google/protobuf/struct.pb.dart'
    as struct_pb;

void main() {
  group('parseKycSchema', () {
    test('returns empty list for null schema', () {
      expect(parseKycSchema(null), isEmpty);
    });

    test('returns empty list for empty struct', () {
      expect(parseKycSchema(struct_pb.Struct()), isEmpty);
    });

    test('parses schema from "schema" key', () {
      final schema = struct_pb.Struct();
      schema.fields['schema'] = struct_pb.Value(
        listValue: struct_pb.ListValue(values: [
          struct_pb.Value(
            structValue: struct_pb.Struct()
              ..fields['key'] =
                  struct_pb.Value(stringValue: 'monthly_income')
              ..fields['label'] =
                  struct_pb.Value(stringValue: 'Monthly Income')
              ..fields['type'] =
                  struct_pb.Value(stringValue: 'number')
              ..fields['required'] =
                  struct_pb.Value(boolValue: true)
              ..fields['group'] =
                  struct_pb.Value(stringValue: 'financial')
              ..fields['hint'] = struct_pb.Value(
                  stringValue: 'Gross monthly income in KES'),
          ),
          struct_pb.Value(
            structValue: struct_pb.Struct()
              ..fields['key'] =
                  struct_pb.Value(stringValue: 'full_name')
              ..fields['label'] =
                  struct_pb.Value(stringValue: 'Full Name')
              ..fields['type'] =
                  struct_pb.Value(stringValue: 'text')
              ..fields['required'] =
                  struct_pb.Value(boolValue: true)
              ..fields['group'] =
                  struct_pb.Value(stringValue: 'personal'),
          ),
        ]),
      );

      final fields = parseKycSchema(schema);
      expect(fields, hasLength(2));
      expect(fields[0].key, 'monthly_income');
      expect(fields[0].label, 'Monthly Income');
      expect(fields[0].type, 'number');
      expect(fields[0].required, isTrue);
      expect(fields[0].group, 'financial');
      expect(fields[0].hint, 'Gross monthly income in KES');
      expect(fields[1].key, 'full_name');
      expect(fields[1].group, 'personal');
    });

    test('parses select field with options', () {
      final schema = struct_pb.Struct();
      schema.fields['schema'] = struct_pb.Value(
        listValue: struct_pb.ListValue(values: [
          struct_pb.Value(
            structValue: struct_pb.Struct()
              ..fields['key'] =
                  struct_pb.Value(stringValue: 'gender')
              ..fields['label'] =
                  struct_pb.Value(stringValue: 'Gender')
              ..fields['type'] =
                  struct_pb.Value(stringValue: 'select')
              ..fields['options'] = struct_pb.Value(
                listValue: struct_pb.ListValue(values: [
                  struct_pb.Value(stringValue: 'Male'),
                  struct_pb.Value(stringValue: 'Female'),
                  struct_pb.Value(stringValue: 'Other'),
                ]),
              ),
          ),
        ]),
      );

      final fields = parseKycSchema(schema);
      expect(fields, hasLength(1));
      expect(fields[0].type, 'select');
      expect(fields[0].options, ['Male', 'Female', 'Other']);
    });

    test('defaults type to text when missing', () {
      final schema = struct_pb.Struct();
      schema.fields['schema'] = struct_pb.Value(
        listValue: struct_pb.ListValue(values: [
          struct_pb.Value(
            structValue: struct_pb.Struct()
              ..fields['key'] =
                  struct_pb.Value(stringValue: 'notes')
              ..fields['label'] =
                  struct_pb.Value(stringValue: 'Notes'),
          ),
        ]),
      );

      final fields = parseKycSchema(schema);
      expect(fields[0].type, 'text');
    });
  });

  group('groupFields', () {
    test('groups by group value', () {
      final fields = [
        const DynamicFieldDef(
            key: 'name', label: 'Name', type: 'text', group: 'personal'),
        const DynamicFieldDef(
            key: 'income',
            label: 'Income',
            type: 'number',
            group: 'financial'),
        const DynamicFieldDef(
            key: 'dob', label: 'DOB', type: 'date', group: 'personal'),
      ];

      final groups = groupFields(fields);
      expect(groups.keys, containsAll(['personal', 'financial']));
      expect(groups['personal'], hasLength(2));
      expect(groups['financial'], hasLength(1));
    });

    test('empty group goes to General', () {
      final fields = [
        const DynamicFieldDef(
            key: 'notes', label: 'Notes', type: 'text'),
      ];

      final groups = groupFields(fields);
      expect(groups.keys, contains('General'));
    });
  });

  group('structToMap / mapToStruct roundtrip', () {
    test('handles string values', () {
      final original = {'name': 'John', 'city': 'Nairobi'};
      final struct = mapToStruct(original);
      final result = structToMap(struct);
      expect(result['name'], 'John');
      expect(result['city'], 'Nairobi');
    });

    test('handles numeric values', () {
      final original = {'age': 25.0, 'income': 50000.0};
      final struct = mapToStruct(original);
      final result = structToMap(struct);
      expect(result['age'], 25.0);
      expect(result['income'], 50000.0);
    });

    test('handles boolean values', () {
      final original = {'active': true, 'verified': false};
      final struct = mapToStruct(original);
      final result = structToMap(struct);
      expect(result['active'], isTrue);
      expect(result['verified'], isFalse);
    });

    test('handles null values', () {
      final original = {'data': null};
      final struct = mapToStruct(original);
      final result = structToMap(struct);
      expect(result['data'], isNull);
    });

    test('handles empty map', () {
      final struct = mapToStruct({});
      final result = structToMap(struct);
      expect(result, isEmpty);
    });

    test('structToMap returns empty for null', () {
      expect(structToMap(null), isEmpty);
    });
  });

  group('DynamicForm widget', () {
    testWidgets('renders text fields with labels', (tester) async {
      const fields = [
        DynamicFieldDef(
          key: 'name',
          label: 'Full Name',
          type: 'text',
          required: true,
        ),
        DynamicFieldDef(
          key: 'email',
          label: 'Email',
          type: 'text',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicForm(fields: fields),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Full Name *'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('renders number field', (tester) async {
      const fields = [
        DynamicFieldDef(
          key: 'income',
          label: 'Monthly Income',
          type: 'number',
          hint: 'Enter amount',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicForm(fields: fields),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Monthly Income'), findsOneWidget);
    });

    testWidgets('renders boolean field as switch', (tester) async {
      const fields = [
        DynamicFieldDef(
          key: 'consent',
          label: 'I agree',
          type: 'boolean',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicForm(fields: fields),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.text('I agree'), findsOneWidget);
    });

    testWidgets('pre-fills initial values', (tester) async {
      const fields = [
        DynamicFieldDef(
          key: 'name',
          label: 'Name',
          type: 'text',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicForm(
                fields: fields,
                initialValues: const {'name': 'Jane Doe'},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Jane Doe'), findsOneWidget);
    });

    testWidgets('validates required fields', (tester) async {
      final formKey = GlobalKey<DynamicFormState>();
      const fields = [
        DynamicFieldDef(
          key: 'name',
          label: 'Name',
          type: 'text',
          required: true,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicForm(key: formKey, fields: fields),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Validate without filling
      final isValid = formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(isValid, isFalse);
      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('groups fields into sections', (tester) async {
      const fields = [
        DynamicFieldDef(
          key: 'name',
          label: 'Name',
          type: 'text',
          group: 'personal',
        ),
        DynamicFieldDef(
          key: 'income',
          label: 'Income',
          type: 'number',
          group: 'financial',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicForm(fields: fields),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Personal'), findsOneWidget);
      expect(find.text('Financial'), findsOneWidget);
    });
  });
}
