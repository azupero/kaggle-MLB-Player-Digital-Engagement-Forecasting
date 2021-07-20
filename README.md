# MLB-Player-Digital-Engagement-Forecasting
## Overview
### Description
選手がウォークオフ・ホームランを打つ。投手がノーヒッターを達成する。ポストシーズンに向けてチームが熱戦を繰り広げる。私たちは、野球ファンの関心を高めるきっかけのいくつかを知っています。今回、Major League Baseball (MLB) と Google Cloud は、サポーターのエンゲージメントを高め、選手とファンの間に深い関係を築くための他の多くの要因を特定するために、Kaggle コミュニティの協力を求めています。

このスポーツには、数字を重視してきた長い歴史があります。少なくとも4月から10月までの間、野球ファンはほぼ毎日、選手に関する情報を見たり、読んだり、検索したりします。どの選手の情報を求めるかは、選手の成績、チームの順位、人気など、現在はまだ知られていない要素に左右されますが、データサイエンスのおかげで、これらの要素がよりよく理解できるようになりました。

少なくとも1990年代初頭から、MLBはデータの活用でスポーツ界をリードし、データと人間のパフォーマンスを組み合わせることで何が可能になるかを、ファン、選手、コーチ、メディアに示してきました。MLBは、テクノロジーを使ってファンを魅了し、新しいファンに「アメリカの好きな娯楽」を体験する革新的な方法を提供することで、リーダーシップを発揮し続けています。

MLBはGoogle Cloudと協力して、データによってファンの体験を変革しています。Google Cloudは、MLワークフローを統合するGoogle Cloudの新しいプラットフォームであるVertex AIの発売を記念して、このKaggleコンテストを支援しています。

このコンテストでは、ファンがMLB選手のデジタルコンテンツにどのように関わっているかを、将来の日付範囲で毎日予測します。選手のパフォーマンスデータ、ソーシャルメディアのデータ、市場規模などのチーム要因にアクセスできます。成功したモデルは、どのようなシグナルがエンゲージメントと最も強く相関し、影響を与えるかについての新しい洞察を提供します。

MLBのオールスターをシーズン中に予測したり、チームの25人の選手がそれぞれスポットライトを浴びるタイミングを予測したりできたらと想像してみてください。このような洞察は、アメリカの娯楽のファンダメンタルをより深く掘り下げることで可能になります。選手レベルでのデジタル・エンゲージメントを、このようにきめ細かく日常的に理解しようとする、この種の方法としては初めての試みに参加してください。同時に、Google Cloudのデータ分析、Vertex AI、MLOpsツールを使って、MLBがより簡単にイノベーションを起こせるよう支援します。あなたは、MLBのファンと選手のエンゲージメントの未来を形作る一翼を担うことができます。
### Evaluation
Submissionsは、MCMAE（Mean Column-Wise Mean Absolute Error）で評価されます。4つのターゲット変数ごとに平均絶対誤差が計算され、その4つのMAE値の平均値がスコアとなります。
## log
### 2021-06-20
- join
- `nb001`
    - ネストされたjsonをそれぞれpickleに分割
- `nb002`
    - EDA
### 2021-06-22
- `nb003`
    - [MLB lightGBM Starter Dataset&Code[en, ja]](https://www.kaggle.com/columbia2131/mlb-lightgbm-starter-dataset-code-en-ja)
### 2021-06-23
- TimeSeriesAPIにまだ慣れていないので`nb003`の推論部分をじっくり読んだ
    - 一行ずつ渡される？
    - 一部のカラムには欠損が含まれてるっぽい
### 2021-06-24
- `nb004`
    - targetのlag特徴量のみを使ってTimeSeriesAPIに慣れる
        - inference時に特徴量を更新する必要があるため
### 2021-06-27
- `nb004`
    - targetはinference時は提供されないのでlag特徴量は作れなかった
    - train setの期間内のユーザー毎の各targetの統計量を特徴量とした
    - target2のエラーが一番大きくここを改善することが一番インパクトでかそう
### 2021-06-28
- `nb005`
    - データセットのカラムの説明をまとめた
### 2021-06-29
- `nb006`
    - `nb004`を元に特徴量クラスを足していく
### 2021-06-30
- `nb006`
    - LabelEncodingBlockを追加
        - testにtrainに含まれない水準がないか確かめる必要がありそう
### 2021-07-02
- `nb003`
    - 公開notebookと再現性がとれずにいた
    - scoresを`playerId, date`でgroupbyしていなかったのが原因
        - 1日に複数試合(ダブルヘッダー)がある場合を考慮して集計できていなかった
### 2021-07-04
- `nb006`
    - test時のデータセット更新部分を実装した。もう少しスマートなやり方がある気がするが・・・。
        - feature blockをfitで内部状態の更新が必要なものとそうでないもので分けた
        - test時は追加日のデータセットを更新して特徴量を作成する流れ。transformメソッドだけでいいものは推論日のデータだけでいいが現状はそれをinputとしておらず、更新したデータセットから特徴を作る仕組み。
    - もろもろのバグをデバッグ
        - test_dfはindexがdate
        - LightGBMの`objective`をずっと`regression`にしていたので公開notebookと再現がとれなかった -> `mae`に変更
        - test時のdateをsubmissionのdate_playerIdから作っていたためErrorになっていた？
- `nb007`
    - `PlayersLabelEncodingBlock`, `PlayerBoxScoresCountBlock`追加
### 2021-07-05
- 推論時のデバッグの続き
    - 色々修正した
    - `RostersLabelEncoding`時に推論時のtest set shapeが合わない
        - Running時にexampleの0426-0430で推論するためデータセット更新時に重複させてconcatしていたため
### 2021-07-06
- `nb008`
    - `TeamBoxScoresCountBlock`を追加
    - Target2の改善のアイデアを模索するためにも近いうちに大谷選手に絞ってEDAしたい
    - Target2はFeature Importanceから試合成績に関する特徴量が他のtargetと比べて上位にランクインしている印象
- `nb009`
    - `GamesCountBlock`追加
    - ちょいLB下がった
### 2021-07-07
- `nb010`
    - `PlayerTwitterFollowerAggregateBlock`追加
### 2021-07-08
- ある時点での今シーズンの打撃成績やタイトル争いみたいな特徴量を作りたい(OPSとか)
- 予測対象のplayerに絞ってみてもいいかも
- targetのaggregateをもう少し細かくしてもいいかも。対戦チーム別にするとか年別とか。
- セイバーメトリクスを算出
- 最近はバレル%とかいうのもあるらしい
- 打席と打数の違いを調べた。打席を使うシーンは例えば規定打席の算出とかがある。
- 指標については以下のサイトが参考になる
    - [用語解説](https://baseballconcrete.web.fc2.com/glossary.html)
    - [【保存版】セイバーメトリクス指標一覧【基本から分かりやすく解説】](https://takker04035555.com/saber-list/)
### 2021-07-10
- `nb011`
    - 大谷選手を例にしてシーズン毎の成績を特徴量化してみた
    - 選手毎・日毎にaggregateするのでtest時にどうupdateしていくかが課題
### 2021-07-13
- `nb013`
    - LBが悪化している原因をずっと探していたが`PlayerStatsBlock`で集約テーブルをfitメソッド内に実装していたためだった
    - update_blockにするかtransformメソッドで処理する必要がある
### 2021-07-14
- `nb014`
    - `TargetAggregateBlock`にprobを追加
    - `AwardsCountBlock`も追加。FEみた感じだとTop50に食い込むインパクトはなさそう。
    - 公開notebookは2021年4月以降、つまり先月のデータでaggregateしているのでそれにならって修正
    - 直近数ヶ月の月毎のaggregateも効果あるだろうか？
    - 1年前の同じ月とかも
- `nb015`
    - `TargetAggregateBlockの改良
        - 過去3ヶ月で月別にaggregate
- 選手の年齢属性を加えたい
- `nb016`
    - test setに登場する選手のみで学習してみたがCVが悪化したのでやめた
    - `nb014`をベースにコメントアウトしていたブロックを追加
    - target2とtarget4は相関がありそう。互いの四則演算が効くかもしれない
    - フォロワーもtarget同様直近の月のみにしてもいいかも
    - target2はStandings由来の特徴量も効いているので対戦相手との相性を表現してもいい
### 2021-07-15
- `nb017`
    - `PlayersLabelEncodingBlock`に`playerAge`を追加
    - target2とtarget4をかけたもの、割った物を追加
### 2021-07-20
- `nb018`
    - `Datetime2trigonometricEncodingBlock`でday, dayofweekの周期性を表現するためにsin, cosに変換
