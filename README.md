## 온라인 광고 분석 솔루션 ‘SOV’ 구축

### 프로젝트 개요
- 목적: **온라인 광고 분석 솔루션 구축**
- 기간: 2018. 3 ~ 2019. 10(1년 8개월)
- 역할: 서비스 기획, 수집 데이터 선정, 데이터 전처리, 머신러닝 모형 구축
- 핵심 성과: **머신러닝 기반 분석 솔루션 구축으로 가입 기업 1,200여 곳 달성**
- Skills: R(data.table, DBI, RMySQL, plyr 등), MySQL

### 추진 배경
광고 회사에서 근무할 당시, 광고 현황을 파악하기 위해 필수적으로 사용해야 하는 솔루션이 있었습니다. 
하지만 해당 솔루션은 타겟팅이 적용된 광고를 수집하지 않아, 타겟팅을 적용한 업종이나 광고주의 광고 현황을 분석하기 어려웠습니다. 
또한, 해당 솔루션의 이용료가 1년 만에 2배 증가하면서 이를 대체하기 위해 **자체 광고 분석 솔루션을 구축**하게 되었습니다.

### 진행 과정
 자체 광고 분석 솔루션은 기존 솔루션과 크게 3가지의 차별점을 주었습니다. 우선 **수집하는 데이터를 성·연령 타겟팅 광고까지 확장**했습니다. 매체마다 성·연령별 가상 계정을 만들어 광고 정보를 수집하여 제공했습니다. 이를 통해 타겟팅을 적용한 업종이나 광고주의 광고 현황도 분석할 수 있게 되었고, 경쟁사의 타겟팅 전략을 확인할 수 있게 되었습니다. 두 번째로 **제공하는 데이터의 단위를 세분화**했습니다. 기존 솔루션은 매체 단위로 광고 데이터를 제공했기 때문에 어떤 광고 상품을 집행했는지 파악할 수 없었습니다. 그래서 머신러닝을 기반으로 광고 상품별 광고비 추정 모형을 구축하여 광고 상품 단위의 광고비 데이터를 제공했습니다. 이를 통해 기존 솔루션 대비 추정 광고비의 정확도를 최대 30% 개선할 수 있었습니다. 세 번째로는 **직관적인 대시보드를 제공**했습니다. 마케팅팀에서 사용하던 광고 현황 리포트의 템플릿을 참고하여 대시보드를 구성했습니다. 이를 통해 마케팅팀의 광고 현황 분석 업무 시간을 1시간에서 10분으로 단축시킬 수 있었습니다.

- 데이터 수집: (웹 크롤링) 네이버, 카카오, 유튜브, 페이스북, 쿠팡 등 주요 광고 지면 데이터
- 데이터 전처리: 소재 라벨링, 건축 업종 제외(대부분 지역 타겟팅이 설정되어 광고 수집의 한계)
- 변수 설정: (독립) 성·연령 타겟팅(추정), 광고 수집 횟수 / (종속) 광고 상품별 광고비
- 분석 모형: 다중 회귀 분석

### 결론
 결과적으로 기존에 이용하던 솔루션을 대체하여 연 7,000만 원의 비용을 절감할 수 있었습니다. 
 또한, 솔루션 오픈 3년 만에 **가입자 기준으로 1,200여 개 기업과 3,000여 명의 이용자가 활용하는 광고 솔루션으로 성장**할 수 있었습니다.

### 파일 링크
[#1. R을 활용한 광고비 추정 모형 구축](https://github.com/hyewon0403/online-advertising-analysis-solution-SOV/blob/master/SOV_naver_brandingDA.R)\
[#2. SOV 소개서](https://github.com/hyewon0403/online-advertising-analysis-solution-SOV/blob/master/SOV%20%EC%86%8C%EA%B0%9C%EC%84%9C.pdf)\
[#3. 분석 리포트](https://github.com/hyewon0403/online-advertising-analysis-solution-SOV/blob/master/2020%20%EC%98%A8%EB%9D%BC%EC%9D%B8%20%EA%B4%91%EA%B3%A0%EB%B9%84%20%EA%B2%B0%EC%82%B0.pdf)
