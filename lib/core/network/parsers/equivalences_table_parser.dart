import 'package:html/dom.dart';

typedef EquivalenceRow = ({
  String code,
  String name,
  String grade,
  String typology,
  String component,
  int credits,
});

/// Returns an empty list when the report has no equivalences table, which is
/// the common case.
List<EquivalenceRow> parseEquivalences(Document report) {
  // The table has no id or class of its own; its only stable marker is a
  // header cell reading "EQUIVALENCIAS".
  final marker = report
      .querySelectorAll('td')
      .where((cell) => cell.text.trim() == 'EQUIVALENCIAS')
      .firstOrNull;

  Element? table = marker?.parent;
  while (table != null && table.localName != 'table') {
    table = table.parent;
  }
  if (table == null) return const [];

  return table
      .querySelectorAll('tr')
      .map(_parseRow)
      .whereType<EquivalenceRow>()
      .toList();
}

EquivalenceRow? _parseRow(Element row) {
  final cells = row.querySelectorAll('td');
  // Data rows have 6 columns; the header row has the same shape but starts
  // with "CODIGO".
  if (cells.length != 6) return null;
  final code = cells[0].text.trim();
  if (code == 'CODIGO') return null;

  return (
    code: code,
    name: cells[1].text.trim(),
    grade: cells[2].text.trim(),
    typology: cells[3].text.trim(),
    component: cells[4].text.trim(),
    credits: int.tryParse(cells[5].text.trim()) ?? 0,
  );
}
