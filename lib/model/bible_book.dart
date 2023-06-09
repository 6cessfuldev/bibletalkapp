class BibleBook {
  final String name;
  final int chapters;
  final List<int> versesPerChapter;

  BibleBook({required this.name, required this.chapters, required this.versesPerChapter});
}

final List<BibleBook> oldTestamentBooks = [
BibleBook(name: '창세기', chapters: 50, versesPerChapter: [31, 25, 24, 26, 32, 22, 24, 22, 29, 32, 32, 20, 18, 24, 21, 16, 27, 33, 38, 18, 34, 24, 20, 67, 34, 35, 46, 22, 35, 43, 54, 30, 25, 24, 43, 23, 57, 38, 34, 34, 28, 34, 31, 22, 33, 26]),
BibleBook(name: '출애굽기', chapters: 40, versesPerChapter: [22, 25, 22, 31, 23, 30, 25, 32, 35, 29, 10, 51, 22, 31, 27, 36, 16, 27, 25, 26, 36, 31, 33, 18, 40, 37, 21, 43, 46, 38, 18, 35, 23, 35, 35, 38, 29, 31, 43, 38]),
BibleBook(name: '레위기', chapters: 27, versesPerChapter: [17, 16, 17, 35, 19, 30, 38, 36, 24, 20, 47, 8, 59, 57, 33, 34, 16, 30, 37, 27, 24, 33, 44, 23, 55, 46, 34]),
BibleBook(name: '민수기', chapters: 36, versesPerChapter: [54, 34, 51, 49, 31, 27, 89, 26, 23, 36, 35, 16, 33, 45, 41, 50, 13, 32, 22, 29, 35, 41, 30, 25, 18, 65, 23, 31, 39, 17, 54, 42, 56, 29, 34, 13]),
BibleBook(name: '신명기', chapters: 34, versesPerChapter: [46, 37, 29, 49, 33, 25, 26, 20, 29, 22, 32, 31, 19, 29, 23, 22, 20, 22, 21, 20, 23, 30, 25, 22, 19, 19, 26, 68, 29, 20, 30, 52, 29, 12]),
BibleBook(name: '여호수아', chapters: 24, versesPerChapter: [18, 24, 17, 24, 15, 27, 26, 35, 27, 43, 23, 24, 33, 15, 63, 10, 18, 28, 51, 9, 45, 34, 16, 33]),
BibleBook(name: '사사기', chapters: 21, versesPerChapter: [16, 47, 26, 37, 42, 15, 60, 40, 43, 48, 30, 25, 52, 28, 41, 40, 34, 28, 41, 38, 40, 30, 35, 27, 27, 32, 44, 31]),
BibleBook(name: '룻기', chapters: 4, versesPerChapter: [22, 23, 18, 22]),
BibleBook(name: '사무엘상', chapters: 31, versesPerChapter: [28, 36, 21, 22, 12, 21, 17, 22, 27, 27, 15, 25, 23, 52, 35, 23, 58, 30, 24, 42, 15, 23, 29, 22, 44, 25, 12, 25, 11, 31, 13]),
BibleBook(name: '사무엘하', chapters: 24, versesPerChapter: [27, 32, 39, 12, 25, 23, 29, 18, 13, 19, 27, 31, 39, 33, 37, 23, 29, 33, 43, 26, 22, 51, 39, 25]),
BibleBook(name: '열왕기상', chapters: 22, versesPerChapter: [54, 55, 24, 43, 26, 81, 40, 40, 44, 14, 47, 40, 14, 17, 29, 43, 27, 17, 19, 8, 30, 19, 32, 31, 31, 32, 34, 21, 30]),
BibleBook(name: '열왕기하', chapters: 25, versesPerChapter: [8, 66, 52, 5, 27, 15, 68, 43, 27, 53, 42, 56, 37, 38, 50, 52, 33, 44, 37, 72, 47, 20]),
BibleBook(name: '역대상', chapters: 29, versesPerChapter: [21, 49, 30, 37, 31, 28, 28, 27, 27, 21, 45, 13, 65, 42, 17, 41, 22, 2, 29, 36, 21, 21, 25, 29, 38, 20, 41, 37, 37, 21, 26, 20, 37, 20, 30]),
BibleBook(name: '역대하', chapters: 36, versesPerChapter: [54, 55, 24, 43, 26, 81, 40, 40, 44, 14, 47, 40, 14, 17, 29, 43, 27, 17, 19, 8, 30, 19, 32, 31, 31, 32, 34, 21, 30, 17, 25, 23, 53, 28, 11, 33, 26, 23, 29, 49, 26, 20, 27, 31, 25, 24, 23, 35]),
BibleBook(name: '에스라', chapters: 10, versesPerChapter: [11, 70, 13, 24, 17, 22, 28, 36, 15, 44]),
BibleBook(name: '느헤미야', chapters: 13, versesPerChapter: [11, 20, 32, 23, 19, 19, 73, 18, 38, 39, 36, 47, 31]),
BibleBook(name: '에스더', chapters: 10, versesPerChapter: [22, 23, 15, 17, 14, 14, 10, 17, 32, 3]),
BibleBook(name: '욥기', chapters: 42, versesPerChapter: [22, 13, 26, 21, 27, 30, 21, 22, 35, 22, 20, 25, 28, 22, 35, 22, 16, 21, 29, 29, 34, 30, 17, 25, 6, 14, 23, 28, 25, 31, 40, 22, 33, 37, 16, 33, 24, 41, 30, 24, 34, 17]),
BibleBook(name: '시편', chapters: 150, versesPerChapter: [6, 12, 8, 8, 12, 10, 17, 9, 20, 18, 7, 8, 6, 7, 5, 11, 15, 50, 14, 9, 13, 31, 6, 10, 22, 12, 14, 9, 11, 12, 24, 11, 22, 22, 28, 12, 40, 22, 13, 17, 13, 11, 5, 26, 17, 11, 9, 14, 20, 23, 19, 9, 6, 7, 23, 13, 11, 11, 17, 12, 8, 12, 11, 10, 13, 20, 7, 35, 36, 5, 24, 20, 28, 23, 10, 12, 20, 72, 13, 19, 16, 8, 18, 12, 13, 17, 7, 18, 52, 17, 16, 15, 5, 23, 11, 13, 12, 9, 9, 5, 8, 28, 22, 35, 45, 48, 43, 13, 31, 7, 10, 10, 9, 8, 18, 19, 2, 29, 176, 7, 8, 9, 4, 8, 5, 6, 5, 6, 8, 8, 3, 18, 3, 3, 21, 26, 9, 8, 24, 13, 10, 7, 12, 15, 21, 10, 20, 14, 9, 6]),
BibleBook(name: '잠언', chapters: 31, versesPerChapter: [33, 22, 35, 27, 23, 35, 27, 36, 18, 32, 31, 28, 25, 35, 33, 33, 28, 24, 29, 30, 31, 29, 35, 34, 28, 28, 27, 28, 27, 33, 31]),
BibleBook(name: '전도서', chapters: 12, versesPerChapter: [20, 29, 22, 11, 14, 17, 17, 13, 21, 11, 19, 17]),
BibleBook(name: '아가', chapters: 8, versesPerChapter: [15, 16, 15, 13, 27, 14, 17, 14, 15]),
BibleBook(name: '이사야', chapters: 66, versesPerChapter: [31, 22, 26, 6, 30, 13, 25, 22, 21, 34, 16, 6, 22, 32, 9, 14, 14, 7, 25, 6, 17, 25, 18, 23, 12, 21, 13, 29, 24, 33, 9, 20, 24, 17, 10, 22, 38, 22, 8, 31, 29, 25, 28, 28, 25, 13, 15, 22, 26, 11, 23, 15, 12, 17, 13, 12, 21, 14, 21, 22, 11, 12, 19, 12, 25, 24]),
BibleBook(name: '예레미야', chapters: 52, versesPerChapter: [19, 37, 25, 31, 31, 30, 34, 22, 26, 25, 23, 17, 27, 22, 21, 21, 27, 23, 15, 18, 14, 30, 40, 10, 38, 24, 22, 17, 32, 24, 40, 44, 26, 22, 19, 32, 21, 28, 18, 16, 18, 22, 13, 30, 5, 28, 7, 47, 39, 46, 64, 34]),
BibleBook(name: '예레미야애가', chapters: 5, versesPerChapter: [22, 22, 66, 22, 22]),
BibleBook(name: '에스겔', chapters: 48, versesPerChapter: [28, 10, 27, 17, 17, 14, 27, 18, 11, 22, 25, 28, 23, 23, 8, 63, 24, 32, 14, 49, 32, 31, 49, 27, 17, 21, 36, 26, 21, 26, 18, 32, 33, 31, 15, 38, 28, 23, 29, 49, 26, 20, 27, 31, 25, 24, 23, 35]),
BibleBook(name: '다니엘', chapters: 12, versesPerChapter: [21, 49, 30, 37, 31, 28, 28, 27, 27, 21, 45, 13]),
BibleBook(name: '호세아', chapters: 14, versesPerChapter: [11, 23, 5, 19, 15, 11, 16, 14, 17, 15, 12, 14, 16, 9]),
BibleBook(name: '요엘', chapters: 3, versesPerChapter: [21, 32, 21]),
BibleBook(name: '아모스', chapters: 9, versesPerChapter: [15, 16, 15, 13, 27, 14, 17, 14, 15]),
BibleBook(name: '오바댜', chapters: 1, versesPerChapter: [21]),
BibleBook(name: '요나', chapters: 4, versesPerChapter: [17, 10, 10, 11]),
BibleBook(name: '미가', chapters: 7, versesPerChapter: [16, 13, 12, 13, 15, 16, 20]),
BibleBook(name: '나훔', chapters: 3, versesPerChapter: [15, 13, 19]),
BibleBook(name: '하박국', chapters: 3, versesPerChapter: [17, 20, 19]),
BibleBook(name: '스바냐', chapters: 3, versesPerChapter: [18, 15, 20]),
BibleBook(name: '학개', chapters: 2, versesPerChapter: [15, 23]),
BibleBook(name: '스가랴', chapters: 14, versesPerChapter: [21, 13, 10, 14, 11, 15, 14, 23, 17, 12, 17, 14, 9, 21]),
BibleBook(name: '말라기', chapters: 4, versesPerChapter: [14, 17, 18, 6]),
];

final List<BibleBook> newTestamentBooks = [
BibleBook(name: '마태복음', chapters: 28, versesPerChapter: [25, 23, 17, 25, 48, 34, 29, 34, 38, 42, 30, 50, 58, 36, 39, 28, 27, 35, 30, 34, 46, 46, 39, 51, 46, 75, 66, 20]),
BibleBook(name: '마가복음', chapters: 16, versesPerChapter: [45, 28, 35, 41, 43, 56, 37, 38, 50, 52, 33, 44, 37, 72, 47, 20]),
BibleBook(name: '누가복음', chapters: 24, versesPerChapter: [80, 52, 38, 44, 39, 49, 50, 56, 62, 42, 54, 59, 35, 35, 32, 31, 37, 43, 48, 47, 38, 71, 56, 53]),
BibleBook(name: '요한복음', chapters: 21, versesPerChapter: [51, 25, 36, 54, 47, 71, 53, 59, 41, 42, 57, 50, 38, 31, 27, 33, 26, 40, 42, 31, 25]),
BibleBook(name: '사도행전', chapters: 28, versesPerChapter: [26, 47, 26, 37, 42, 15, 60, 40, 43, 48, 30, 25, 52, 28, 41, 40, 34, 28, 41, 38, 40, 30, 35, 27, 27, 32, 44, 31]),
BibleBook(name: '로마서', chapters: 16, versesPerChapter: [32, 29, 31, 25, 21, 23, 25, 39, 33, 21, 36, 21, 14, 26, 33, 24]),
BibleBook(name: '고린도전서', chapters: 16, versesPerChapter: [31, 16, 23, 21, 13, 20, 40, 13, 27, 33, 34, 31, 13, 40, 58, 24]),
BibleBook(name: '고린도후서', chapters: 13, versesPerChapter: [24, 17, 18, 18, 21, 18, 16, 24, 15, 18, 33, 21, 14]),
BibleBook(name: '갈라디아서', chapters: 6, versesPerChapter: [24, 21, 29, 31, 26, 18]),
BibleBook(name: '에베소서', chapters: 6, versesPerChapter: [23, 22, 21, 32, 33, 24]),
BibleBook(name: '빌립보서', chapters: 4, versesPerChapter: [30, 30, 21, 23]),
BibleBook(name: '골로새서', chapters: 4, versesPerChapter: [29, 23, 25, 18]),
BibleBook(name: '데살로니가전서', chapters: 5, versesPerChapter: [10, 20, 13, 18, 28]),
BibleBook(name: '데살로니가후서', chapters: 3, versesPerChapter: [12, 17, 18]),
BibleBook(name: '디모데전서', chapters: 6, versesPerChapter: [11, 19, 17, 18, 20, 13]),
BibleBook(name: '디모데후서', chapters: 4, versesPerChapter: [20, 15, 16, 16]),
BibleBook(name: '디도서', chapters: 3, versesPerChapter: [21, 13, 14]),
BibleBook(name: '빌레몬서', chapters: 1, versesPerChapter: [25]),
BibleBook(name: '히브리서', chapters: 13, versesPerChapter: [14, 18, 19, 16, 14, 20, 28, 13, 28, 39, 40, 29, 25]),
BibleBook(name: '야고보서', chapters: 5, versesPerChapter: [27, 26, 18, 17, 20]),
BibleBook(name: '베드로전서', chapters: 5, versesPerChapter: [25, 25, 22, 19, 14]),
BibleBook(name: '베드로후서', chapters: 3, versesPerChapter: [21, 22, 18]),
BibleBook(name: '요한일서', chapters: 5, versesPerChapter: [10, 29, 24, 21, 21]),
BibleBook(name: '요한이서', chapters: 1, versesPerChapter: [13]),
BibleBook(name: '요한삼서', chapters: 1, versesPerChapter: [14]),
BibleBook(name: '유다서', chapters: 1, versesPerChapter: [25]),
BibleBook(name: '요한계시록', chapters: 22, versesPerChapter: [20, 29, 22, 11, 14, 17, 17, 13, 21, 11, 19, 17, 18, 20, 8, 21, 18, 24, 21, 15, 27, 21]),
];