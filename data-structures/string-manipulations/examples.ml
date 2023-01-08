(** 文字列中に登場する文字について、重複する文字がないかどうかを判定するプログラム *)

(**
   ポイント：
   - Ascii なのか Unicode なのか
   - ここではAsciiとする
   - Asciiであれば、文字の種類は2^7=128文字、拡張Asciiであれば種類は2^8=256文字
   - 上記よりも長い文字列は重複する文字を含んでいるため、その時点でfalseとすることが可能   

   Asciiで表現される文字列に対して、重複する文字が含まれるかどうかを判定するプログラム例は以下のようになる。   
*)


(**
   アルゴリズムの検討

   まず出現した文字を記録する場所（mem_table）が必要。リスト、配列、ハッシュテーブル等。
   大まかな流れは
   1.  128文字を超えていればfalseを返す
   2.  文字列の先頭から1文字（c）取り出す
   3.1 cがmem_tableになければcをmem_tableに記録し、c以降の文字列に対して2.から実行する
   3.2 cがmem_tableにすでに存在すればfalseを返す。ここで終了
   4.  文字列の長さが0以下になっている場合、重複した文字が存在しなかったことになるのでtrueを返す
*)

let is_unique_string str =
  let mem_table = Hashtbl.create 128 in
  if String.length str > 128 then false
  else
    let rec is_unique_string_i str mem_table rslt =
      if String.length str <= 0 || rslt = false then rslt
      else
        (* Get first char from str and check whether the char exists in mem_table or not. *)
        let c = str.[0] in
        match Hashtbl.find_opt mem_table c with
        | None -> (Hashtbl.add mem_table c 1; (is_unique_string_i [@tailcall]) (String.sub str 1 (String.length str - 1)) mem_table true)
        | Some _ -> (is_unique_string_i [@tailcall]) "" mem_table false
    in (is_unique_string_i [@tailcall]) str mem_table true

(** test
    is_unique_string "abc" (* true *)
    is_unique_string "abca" (* false *)
*)

(**
   文字列の長さをnとすると、1つずつ文字の重複チェックするため時間計算量はO(n)である。
   ただし、128文字を超えることはないためO(128) = O(1)と言っても良い。
   また、空間計算量は末尾再帰最適化によってO(1)となっている。
*)
    
