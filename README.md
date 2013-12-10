# Music Data Model

## artists

| field          | type     | description            |
| ---------      | -------  | ---------------------- |
| id             | integer  | primary identifier     |
| musicbrainz_id | string   | MusicBrainz identifier |
| lastfm_id      | string   | Last.FM identifier     |
| echonest_id    | string   | EchoNest identifier    |
| whosampled_id  | string   | WhoSampled identifier  |
| name           | string   | name of artist         |
| created_at     | datetime | time created           |
| updated_at     | datetime | time updated           |

## albums

| field      | type     | description        |
| ---------- | -------- | ------------------ |
| id         | integer  | primary identifier |
| artist_id  | integer  | primary identifier |
| name       | string   | album  name        | # lastfm
| created_at | datetime | time created       |
| updated_at | datetime | time updated       |

## tracks

| field          | type     | description                |
| -------------- | -------- | -------------------------- |
| id             | integer  | primary identifier         |
| musicbrainz_id | string   | MusicBrainz identifier     | # lastfm
| lastfm_id      | string   | Last.FM identifier         | # lastfm
| name           | string   | track name                 | # lastfm
| duration       | float    | track duration             | # lastfm
| position       | integer  | Position of track on album | # lastfm
| created_at     | datetime | time created               |
| updated_at     | datetime | time updated               |

## reviews

| field      | type     | description        |
| ---------- | -------- | ------------------ |
| id         | integer  | primary identifier |
| artist_id  | integer  | artist identifier  |
| source     | string   | api source name    |
| body       | text     | review text        |
| created_at | datetime | time created       |
| updated_at | datetime | time updated       |

## biographies

| field      | type     | description        |
| ---------- | -------- | ------------------ |
| id         | integer  | primary identifier |
| artist_id  | integer  | artist identifier  |
| source     | string   | api source name    |
| body       | text     | biography text     |
| created_at | datetime | time created       |
| updated_at | datetime | time updated       |

## tags

| field      | type     | description        |
| ---------- | -------- | ------------------ |
| id         | integer  | primary identifier |
| name       | string   | tag name           |
| created_at | datetime | time created       |
| updated_at | datetime | time updated       |

## terms

| field      | type     | description             |
| ---------- | -------- | ----------------------- |
| id         | integer  | primary identifier      |
| name       | string   | name of term            |
| type       | string   | term type (mood, style) |
| created_at | datetime | time created            |
| updated_at | datetime | time updated            |

## data_collections (polymorphic, STI)

| field          | type     | description                                     |
| -------------- | -------- | ----------------------------------------------- |
| id             | integer  | primary identifier                              |
| collectible_id | integer  | collectible identifier                          |
| type           | string   | type of collectible item (artist, album, track) |
| year_to        | string   | date disbanded                                  | # artist/lastfm
| year_from      | string   | date formed                                     | # artist/lastfm
| hotttness      | float    | buzz factor                                     | # artist/echonest
| familiarity    | float    | well-known factor                               | # artist/echonest
| currency       | float    | currency factor                                 | # artist/echonest
| location       | hash     | artist location                                 | # artist/echonest
| listeners      | integer  | Number of listeners on Last.FM                  | # artist,track/lastfm
| playcount      | integer  | Number of plays on Last.FM                      | # artist,track/lastfm
| created_at     | datetime | time created                                    |
| updated_at     | datetime | time updated                                    |

## data_comparisons (polymorphic, STI)

| field            | type     | description                                                                                           |
| ---------------- | -------- | ----------------------------------------------------------------------------------------------------- |
| id               | integer  | primary identifier                                                                                    |
| type             | string   | type of camparable item (artist-artists, track-track, artist-term, artist-tag, track-term, track-tag) |
| comparable_id    | integer  | comparable identifier                                                                                 |
| compared_to_id   | integer  | compared to identifier                                                                                |
| score            | float    | similarity between comparable items                                                                   |
| created_at       | datetime | time created                                                                                          |
| updated_at       | datetime | time updated                                                                                          |
