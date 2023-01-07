# データ構造

## ハッシュテーブル

キーと値をハッシュ値によって管理するデータ構造のこと。

プログラミング言語でプリミティブに提供されているものもあれば、同様のデータ構造を自作しなければいけないものもある。

---
    Key, Data                         Hash table
                                     +----+   +------+
    ("Apple", "The color is red.")-->| 01 |-->|Apple |
                                     +----+   +------+
                                     +----+   +------+
    ("Orange", "The color is ...")-->| 02 |-->|Orange|
                                     +----+   +------+
                                     +----+   +------+
    ("Grape", "The color is ....")-->| 03 |-->|Grape |
                                     +----+   +------+
                                     +----+   +---------+   +-----+
    ("Pineapple","The color ....")-->| 04 |-->|Pineapple|-->|Berry|
                                     +----+   +---------+   +-----+
                                    /
    ("Berry", "The color is ....")-+

---

ハッシュテーブルで気をつけるべき点は以下のとおり。

* 異なるキーに対して同一のハッシュ値が与えられるシノニムが発生する点

ハッシュテーブルを2分探索木で実装しても良い。その場合の時間計算量はO(log N)となる。
巨大なハッシュテーブルを割り当てることができない場合に有効。

ハッシュ値の求め方は様々考えられるが、一般的な実装では`キーから算出したハッシュ値 % ハッシュテーブルの長さ # %は除算の余りを返す`となっていることがある。

とはいえ、ハッシュテーブルが提供するのは高速（例えばO(1)くらい）なルックアップ、追加、削除であるため、
map等の可変長なハッシュテーブルの場合、ハッシュテーブルの長さで割る必要もないので、キーまたはハッシュ値をそのまま使うのが楽。

```golang
package main

import "fmt"

type KVTable map[string][]string

func main() {
	kv := make(KVTable)
	kv["Apple"] = []string{"The color is red."}
	kv["Orange"] = []string{"The color is ..."}
	// ...
	kv["Pineapple"] = []string{"The color ..."}

	fmt.Println(kv)
}
```

Reference: https://go.dev/blog/maps

愚直に実装する場合はこんな感じ。

```golang
type HashTable struct {
	Size int
	Data [][]*Entry
}

type Entry struct {
	Key   string
	Value string
}

func NewHashTable(initialSize int) *HashTable {
	return &HashTable{
		Size: initialSize,
		Data: make([][]*Entry, initialSize),
	}
}

// キーをハッシュ値にして、ハッシュテーブルの長さで割った余りを返す
func (h *HashTable) GetBucket(key string) int {
	return abs(hash(key)) % len(h.Size) // absは絶対値を返す関数
}

// ハッシュテーブルにKey,Valueを追加する
func (h *HashTable) Put(key string, value string) error {
	bucket := h.GetBucket(key)
	h[bucket] = append(h[bucket], Data{Key: key, Value: value})
	// ...
	return nil
}
```
