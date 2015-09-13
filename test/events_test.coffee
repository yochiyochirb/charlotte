Helper = require('hubot-test-helper')
expect = require('chai').expect
nock = require('nock')

helper = new Helper('./../scripts/events.coffee')

yochiyochirbResponse = [
  {
    event: {
      title: "よちよち.rb 第xx回",
      id: 65535,
      starts_at: "2015-09-14T11:00:00.000Z",
      ends_at: "2015-09-14T13:00:00.000Z",
      venue_name: "株式会社よちよち",
      address: "東京都渋谷区xxxxx",
      lat: null,
      long: null,
      ticket_limit: 15,
      published_at: "2015-09-09T04:32:05.292Z",
      updated_at: "2015-09-10T16:01:28.959Z",
      group: 2203,
      description: "p",
      public_url: "https://yochiyochirb.doorkeeper.jp/events/xxxxx",
      participants: 9,
      waitlisted: 0
    },
    event: {
      title: "よちよちスーパーもくもく会 第xx回",
      id: 65536,
      starts_at: "2015-09-19T05:00:00.000Z",
      ends_at: "2015-09-19T10:00:00.000Z",
      venue_name: "合同会社yochiyochi",
      address: "東京都品川区xxxxx",
      lat: null,
      long: null,
      ticket_limit: 20,
      published_at: "2015-09-09T04:32:05.292Z",
      updated_at: "2015-09-10T16:01:28.959Z",
      group: 2203,
      description: "p",
      public_url: "https://yochiyochirb.doorkeeper.jp/events/xxxxx",
      participants: 15,
      waitlisted: 0
    }
  }
]

yochiyochibeerResponse = [
  {
    event: {
      title: "よちよち.beer 第xx回",
      id: 65537,
      starts_at: "2015-09-14T11:00:00.000Z",
      ends_at: "2015-09-14T13:00:00.000Z",
      venue_name: "バーよちよち",
      address: "東京都新宿区xxxxx",
      lat: null,
      long: null,
      ticket_limit: 15,
      published_at: "2015-09-09T04:32:05.292Z",
      updated_at: "2015-09-10T16:01:28.959Z",
      group: 2204,
      description: "p",
      public_url: "https://yochiyochirb.doorkeeper.jp/events/xxxxx",
      participants: 10,
      waitlisted: 0
    }
  }
]

describe 'events', ->

  beforeEach ->
    @room = helper.createRoom()
    do nock.disableNetConnect

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  context 'user says "events" and both yochiyochirb and yochiyochibeer events are available', ->
    beforeEach (done) ->
      nock('http://api.doorkeeper.jp/')
        .get('/groups/yochiyochirb/events')
        .reply 200, yochiyochirbResponse
        .get('/groups/yochiyochibeer/events')
        .reply 200, yochiyochibeerResponse
      @room.user.say 'alice', 'hubot events'
      setTimeout done, 100

    it 'should tell published events to user', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot events']
        [
          'hubot',
          ":hatching_chick: :baby_chick: よちよち.rb の公開中のイベント :hatching_chick: :baby_chick:\n\n:star2: よちよちスーパーもくもく会 第xx回\n:calendar: 2015年09月19日 14:00\n:earth_asia: 合同会社yochiyochi\nhttps://yochiyochirb.doorkeeper.jp/events/xxxxx\n\n\n:beers: :beer: よちよち.beer の公開中のイベント :beers: :beer:\n\n:star2: よちよち.beer 第xx回\n:calendar: 2015年09月14日 20:00\n:earth_asia: バーよちよち\nhttps://yochiyochirb.doorkeeper.jp/events/xxxxx\n\n"
        ]
      ]

  context 'user says "event" and both yochiyochirb and yochiyochibeer events are available', ->
    beforeEach (done) ->
      nock('http://api.doorkeeper.jp/')
        .get('/groups/yochiyochirb/events')
        .reply 200, yochiyochirbResponse
        .get('/groups/yochiyochibeer/events')
        .reply 200, yochiyochibeerResponse
      @room.user.say 'alice', 'hubot event'
      setTimeout done, 100

    it 'should tell published events to user', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot event']
        [
          'hubot',
          ":hatching_chick: :baby_chick: よちよち.rb の公開中のイベント :hatching_chick: :baby_chick:\n\n:star2: よちよちスーパーもくもく会 第xx回\n:calendar: 2015年09月19日 14:00\n:earth_asia: 合同会社yochiyochi\nhttps://yochiyochirb.doorkeeper.jp/events/xxxxx\n\n\n:beers: :beer: よちよち.beer の公開中のイベント :beers: :beer:\n\n:star2: よちよち.beer 第xx回\n:calendar: 2015年09月14日 20:00\n:earth_asia: バーよちよち\nhttps://yochiyochirb.doorkeeper.jp/events/xxxxx\n\n"
        ]
      ]

  context 'user says "events" and both yochiyochirb and yochiyochibeer events are available but empty', ->
    beforeEach (done) ->
      nock('http://api.doorkeeper.jp/')
        .get('/groups/yochiyochirb/events')
        .reply 200, []
        .get('/groups/yochiyochibeer/events')
        .reply 200, []
      @room.user.say 'alice', 'hubot events'
      setTimeout done, 100

    it 'should tell published events to user', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot events']
        [
          'hubot',
          ":hatching_chick: :baby_chick: よちよち.rb の公開中のイベント :hatching_chick: :baby_chick:\n\n公開中のイベントはありません :ghost:\n\n:beers: :beer: よちよち.beer の公開中のイベント :beers: :beer:\n\n公開中のイベントはありません :ghost:\n"
        ]
      ]

  context 'user says "events" and fails to get yochiyochirb events', ->
    beforeEach (done) ->
      nock('http://api.doorkeeper.jp/')
        .get('/groups/yochiyochirb/events')
        .reply 404, []
        .get('/groups/yochiyochibeer/events')
        .reply 200, []
      @room.user.say 'alice', 'hubot events'
      setTimeout done, 100

    it 'should tell published events to user', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot events']
        [
          'hubot',
          "データ取得エラー :cry:\n"
        ]
      ]

  context 'user says "events" and fails to get yochiyochibeer events', ->
    beforeEach (done) ->
      nock('http://api.doorkeeper.jp/')
        .get('/groups/yochiyochirb/events')
        .reply 200, []
        .get('/groups/yochiyochibeer/events')
        .reply 403, []
      @room.user.say 'alice', 'hubot events'
      setTimeout done, 100

    it 'should tell published events to user', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot events']
        [
          'hubot',
          "データ取得エラー :cry:\n"
        ]
      ]
