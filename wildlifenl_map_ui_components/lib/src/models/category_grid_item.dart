class CategoryGridItem {
  final String text;
  final String? iconPath;

  const CategoryGridItem({required this.text, this.iconPath});

  factory CategoryGridItem.fromMap(Map<String, String> map) {
    return CategoryGridItem(
      text: map['text'] ?? '',
      iconPath: map['icon'],
    );
  }

  Map<String, String> toMap() => {
        'text': text,
        if (iconPath != null) 'icon': iconPath!,
      };
}
