class FlashCard {
  List<Map<String, String>> flashcards = [
    {
      'word': 'candidate',
      'partOfSpeech': 'noun',
      'definition': '후보자, 지원자',
      'example': 'one of the leading candidates for the presidency',
      'exampleTranslation': '대통령 선거 유력 입후보자들 중 한 명',
    },
    {
      'word': 'client',
      'partOfSpeech': 'noun',
      'definition': '고객',
      'example': 'a lawyer with many famous clients',
      'exampleTranslation': '유명한 의뢰인이 많은 변호사',
    },
    {
      'word': 'colleague',
      'partOfSpeech': 'noun',
      'definition': '동료',
      'example': 'a colleague of mine from the office',
      'exampleTranslation': '내 사무실 동료들 중 한 명',
    },
    {
      'word': 'department',
      'partOfSpeech': 'noun',
      'definition': '부서',
      'example': 'the Department of Trade and Industry',
      'exampleTranslation': '무역산업부',
    },
    {
      'word': 'deserve',
      'partOfSpeech': 'verb',
      'definition': '받을만 하다',
      'example': 'You deserve a rest after all that hard work.',
      'exampleTranslation': '그렇게 힘든 일을 했으니 당신은 쉴 자격이 있어.',
    },
    // {
    //   'word': 'employee',
    //   'partOfSpeech': 'noun',
    //   'definition': '직원',
    //   'example': 'The firm has over 500 employees.',
    //   'exampleTranslation': '그 회사는 종업원이 500명이 넘는다.',
    // },
    // {
    //   'word': 'promote',
    //   'partOfSpeech': 'verb',
    //   'definition': '홍보하다, 승진시키다',
    //   'example': 'She worked hard and was soon promoted.',
    //   'exampleTranslation': '그녀는 열심히 일해서 곧 승진되었다.',
    // },
    // {
    //   'word': 'regret',
    //   'partOfSpeech': 'verb',
    //   'definition': '후회하다, 유감',
    //   'example': "If you don’t do it now, you’ll only regret it.",
    //   'exampleTranslation': '네가 지금 그것을 하지 않으면 넌 후회만 하게 될 거야.',
    // },
    // {
    //   'word': 'absence',
    //   'partOfSpeech': 'noun',
    //   'definition': '결석, 부재',
    //   'example': 'absence from work',
    //   'exampleTranslation': '결근',
    // },
    // {
    //   'word': 'afford',
    //   'partOfSpeech': 'verb',
    //   'definition': '여유가 있다',
    //   'example': 'Can we afford a new car?',
    //   'exampleTranslation': '우리가 새 차를 살 여유가 돼요?',
    // },
    // {
    //   'word': 'aware',
    //   'partOfSpeech': 'adjective',
    //   'definition': '알고 있는',
    //   'example':
    //       "I don’t think people are really aware of just how much it costs.",
    //   'exampleTranslation': '난 사람들이 그저 그것에 돈이 얼마나 드는지도 제대로 자각하지 못한다고 생각한다.',
    // },
    // {
    //   'word': 'carelessness',
    //   'partOfSpeech': 'noun',
    //   'definition': '부주의',
    //   'example': 'a moment of carelessness',
    //   'exampleTranslation': '순간적인 부주의',
    // },
    // {
    //   'word': 'disappoint',
    //   'partOfSpeech': 'verb',
    //   'definition': '실망시키다',
    //   'example':
    //       'Her decision to cancel the concert is bound to disappoint her fans.',
    //   'exampleTranslation': '그녀의 그 콘서트 취소 결정은 틀림없이 팬들에게 실망을 안겨 줄 것이다.',
    // },
    // {
    //   'word': 'duty',
    //   'partOfSpeech': 'noun',
    //   'definition': '의무, 임무',
    //   'example': 'It is my duty to report it to the police.',
    //   'exampleTranslation': '그것을 경찰에 알리는 것이 내 의무이다.',
    // },
    // {
    //   'word': 'fulfill',
    //   'partOfSpeech': 'verb',
    //   'definition': '이행하다',
    //   'example': 'fulfill one\'s duties',
    //   'exampleTranslation': '임무를 수행하다',
    // },
    // {
    //   'word': 'beneficial',
    //   'partOfSpeech': 'adjective',
    //   'definition': '이로운',
    //   'example': 'A good diet is beneficial to health.',
    //   'exampleTranslation': '좋은 음식은 건강에 이롭다.',
    // },
    // {
    //   'word': 'irresponsible',
    //   'partOfSpeech': 'adjective',
    //   'definition': '무책임한',
    //   'example': 'an irresponsible teenager',
    //   'exampleTranslation': '무책임한 십대',
    // },
    // {
    //   'word': 'unfortunate',
    //   'partOfSpeech': 'adjective',
    //   'definition': '불행한, 유감스러운',
    //   'example': 'He was unfortunate to lose in the final round.',
    //   'exampleTranslation': '그는 운 나쁘게도 마지막 라운드에서 졌다.',
    // },
    // {
    //   'word': 'application',
    //   'partOfSpeech': 'noun',
    //   'definition': '적용, 응용',
    //   'example': 'the application of new technology to teaching',
    //   'exampleTranslation': '새로운 과학기술을 교수에 적용함',
    // },
    // {
    //   'word': 'chemistry',
    //   'partOfSpeech': 'noun',
    //   'definition': '화학',
    //   'example': 'a degree in chemistry',
    //   'exampleTranslation': '화학 학위',
    // },
    // {
    //   'word': 'coursework',
    //   'partOfSpeech': 'noun',
    //   'definition': '학습 과제, 교과 학습',
    //   'example': 'Coursework accounts for 40% of the final marks.',
    //   'exampleTranslation': '수업 활동이 기말 성적의 40%를 차지한다.',
    // },
    // {
    //   'word': 'electrical',
    //   'partOfSpeech': 'adjective',
    //   'definition': '전기의, 전자의',
    //   'example': 'an electrical fault in the engine',
    //   'exampleTranslation': '엔진의 전기 결함',
    // },
    // {
    //   'word': 'fascinated',
    //   'partOfSpeech': 'adjective',
    //   'definition': '매료된',
    //   'example':
    //       'The children watched, fascinated, as the picture began to appear.',
    //   'exampleTranslation': '영상이 나타나기 시작하자 아이들이 넋을 빼고 지켜보았다.',
    // },
    // {
    //   'word': 'flexible',
    //   'partOfSpeech': 'adjective',
    //   'definition': '유연한',
    //   'example': 'flexible plastic tubing',
    //   'exampleTranslation': '유연한 플라스틱 배관',
    // },
    // {
    //   'word': 'honored',
    //   'partOfSpeech': 'adjective',
    //   'definition': '명예로운, 영광으로 생각하여',
    //   'example': 'I feel highly honored by your kindness.',
    //   'exampleTranslation': '나는 당신의 친절을 큰 영광으로 생각합니다.',
    // },
    // {
    //   'word': 'independent',
    //   'partOfSpeech': 'adjective',
    //   'definition': '독립한, 무소속의',
    //   'example': 'an independent nation',
    //   'exampleTranslation': '독립한 국가',
    // },
    // {
    //   'word': 'introductory',
    //   'partOfSpeech': 'adjective',
    //   'definition': '소개의, 서두의',
    //   'example': 'introductory chapters',
    //   'exampleTranslation': '서론 부분이 되는 장들',
    // },
    // {
    //   'word': 'laboratory',
    //   'partOfSpeech': 'noun',
    //   'definition': '실험실',
    //   'example': 'a research laboratory',
    //   'exampleTranslation': '연구 실험실',
    // },
    // {
    //   'word': 'term',
    //   'partOfSpeech': 'noun',
    //   'definition': '용어, 기간',
    //   'example': 'a technical/legal/scientific, etc. term',
    //   'exampleTranslation': '전문[특수]/법률/과학 용어 등',
    // },
    // {
    //   'word': 'transparent',
    //   'partOfSpeech': 'adjective',
    //   'definition': '투명한',
    //   'example': 'a man of transparent honesty',
    //   'exampleTranslation': '투명한 정직성을 지닌 남자',
    // }
  ];
}
