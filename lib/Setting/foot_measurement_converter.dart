Map<String, dynamic> getShoeSizeRecommendation(double cm, String gender) {
  List<Map<String, dynamic>> sizeChart = [
    {
      'cm': 24.0,
      'men': {'US': 6, 'UK': 5.5, 'EU': '38 2/3'},
      'women': {'US': 7, 'UK': 5, 'EU': '38 2/3'}
    },
    {
      'cm': 24.5,
      'men': {'US': 6.5, 'UK': 6, 'EU': '39 1/3'},
      'women': {'US': 7.5, 'UK': 5.5, 'EU': '39 1/3'}
    },
    {
      'cm': 25.0,
      'men': {'US': 7, 'UK': 6.5, 'EU': '40'},
      'women': {'US': 8, 'UK': 6, 'EU': '40'}
    },
    {
      'cm': 25.5,
      'men': {'US': 7.5, 'UK': 7, 'EU': '40 2/3'},
      'women': {'US': 8.5, 'UK': 6.5, 'EU': '40 2/3'}
    },
    {
      'cm': 26.0,
      'men': {'US': 8, 'UK': 7.5, 'EU': '41 1/3'},
      'women': {'US': 9, 'UK': 7, 'EU': '41 1/3'}
    },
    {
      'cm': 26.5,
      'men': {'US': 8.5, 'UK': 8, 'EU': '42'},
      'women': {'US': 9.5, 'UK': 7.5, 'EU': '42'}
    },
    {
      'cm': 27.0,
      'men': {'US': 9, 'UK': 8.5, 'EU': '42 2/3'},
      'women': {'US': 10, 'UK': 8, 'EU': '42 2/3'}
    },
    {
      'cm': 27.5,
      'men': {'US': 9.5, 'UK': 9, 'EU': '43 1/3'},
      'women': {'US': 10.5, 'UK': 8.5, 'EU': '43 1/3'}
    },
    {
      'cm': 28.0,
      'men': {'US': 10, 'UK': 9.5, 'EU': '44'},
      'women': {'US': 11, 'UK': 9, 'EU': '44'}
    },
    {
      'cm': 28.5,
      'men': {'US': 10.5, 'UK': 10, 'EU': '44 2/3'},
      'women': {'US': 11.5, 'UK': 9.5, 'EU': '44 2/3'}
    },
    {
      'cm': 29.0,
      'men': {'US': 11, 'UK': 10.5, 'EU': '45 1/3'},
      'women': {'US': 12, 'UK': 10, 'EU': '45 1/3'}
    },
    {
      'cm': 29.5,
      'men': {'US': 11.5, 'UK': 11, 'EU': '46'},
      'women': {'US': 12.5, 'UK': 10.5, 'EU': '46'}
    },
    {
      'cm': 30.0,
      'men': {'US': 12, 'UK': 11.5, 'EU': '46 2/3'},
      'women': {'US': 13, 'UK': 11, 'EU': '46 2/3'}
    },
    {
      'cm': 30.5,
      'men': {'US': 12.5, 'UK': 12, 'EU': '47 1/3'},
      'women': {'US': 13.5, 'UK': 11.5, 'EU': '47 1/3'}
    },
    {
      'cm': 31.0,
      'men': {'US': 13, 'UK': 12.5, 'EU': '48'},
      'women': {'US': 14, 'UK': 12, 'EU': '48'}
    },
    {
      'cm': 32.0,
      'men': {'US': 14, 'UK': 13.5, 'EU': '49 1/3'},
      'women': {'US': 15, 'UK': 13, 'EU': '49 1/3'}
    },
    {
      'cm': 33.0,
      'men': {'US': 15, 'UK': 14.5, 'EU': '50 2/3'},
      'women': {'US': 16, 'UK': 14, 'EU': '50 2/3'}
    }
  ];

  Map<String, dynamic> initialSize = {};
  Map<String, dynamic> comfortableSize05 = {};
  Map<String, dynamic> comfortableSize1 = {};

  for (var size in sizeChart) {
    if (cm <= size['cm']) {
      if (initialSize.isEmpty) {
        if (gender.toLowerCase() == 'male') {
          initialSize = size['men'];
        } else if (gender.toLowerCase() == 'female') {
          initialSize = size['women'];
        } else {
          initialSize = {'men': size['men'], 'women': size['women']};
        }
      }
      if (cm + 0.5 <= size['cm'] && comfortableSize05.isEmpty) {
        if (gender.toLowerCase() == 'male') {
          comfortableSize05 = size['men'];
        } else if (gender.toLowerCase() == 'female') {
          comfortableSize05 = size['women'];
        } else {
          comfortableSize05 = {'men': size['men'], 'women': size['women']};
        }
      }
      if (cm + 1 <= size['cm'] && comfortableSize1.isEmpty) {
        if (gender.toLowerCase() == 'male') {
          comfortableSize1 = size['men'];
        } else if (gender.toLowerCase() == 'female') {
          comfortableSize1 = size['women'];
        } else {
          comfortableSize1 = {'men': size['men'], 'women': size['women']};
        }
      }
      if (comfortableSize05.isNotEmpty && comfortableSize1.isNotEmpty) break;
    }
  }

  return {
    'initialSize': initialSize,
    'comfortableSize05': comfortableSize05,
    'comfortableSize1': comfortableSize1
  };
}
