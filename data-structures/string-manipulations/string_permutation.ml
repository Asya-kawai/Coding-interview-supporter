(** 2つの文字列が与えられた時、一方がもう一方の順列になっているかどうかを判定するプログラム *)

(**
   ポイント：
   - 大文字小文字を区別するのかどうか
   - ここでは大文字小文字を区別することにする
   - 空白をどのように扱うか
   - ここでは空白を意味のあるものとする
   - つまり、"dog " != "dog" とする
*)

(**
   アルゴリズム：

   いつくか解法はある。例えば、
   a. 与えられた文字列をソートして、どちらも同じ文字列になっていれば順列になっている
      与えられた文字列の長さがそれぞれn, mである時、またソートの計算量がO(nlogn)の時、全体の時間計算量はO(nlogn + mlogm)である。
*)

(* a.のアルゴリズム *)

(* クイックソートで文字列を並べる関数。ただし末尾再帰最適化ではない *)
let rec qsort str =
  (* xよりも小さいものをleft, それ以外のものをrightに入れる *)
  let rec pivod x left right = function
    | [] -> (left, right)
    | y :: ys ->
      if x > y then (pivod [@tailcall]) x (y :: left) right ys
      else (pivod [@tailcall]) x left (y :: right) ys
  in
  match str with
  | [] -> []
  | x :: xs -> 
    let (left, right) = pivod x [] [] xs in
    (qsort left) @ [x] @ (qsort right)

(* ここでは文字列を、文字を要素に持つ配列として受け取ることにする *)
let is_permutation str1 str2 =
  let sorted_str1 = qsort str1 in
  let sorted_str2 = qsort str2 in
  sorted_str1 = sorted_str2

(**
   アルゴリズム：

   a.以外にも、以下のようなアルゴリズムが考えられる。  
   b. 1つ目の文字列に含まれる文字をカウントするテーブル（配列等）を用意する。

   1.   2つの文字列の長さが同じかどうかチェックし、異なる場合はfalseを返す。ここで終了
   2.   1つ目の文字列から1文字（c）取り出し、カウントを+1してテーブルに記録する（('a', 1)のように）
   3.1. 2つ目の文字列から1文字（c）取り出し、カウントを-1してテーブルに記録する（('a', -1)のように）
   3.2. 値がマイナスになったらfalseを返す。ここで終了
   4.   2つ目の文字列を最後まで捜査できたら両方に出現する文字が同じ数であると分かるのでtrueを返す。
*)

let is_permutation2 str1 str2 =
  let mem_table = Hashtbl.create 128 in
  if (String.length str1) > 128 ||
     (String.length str2) > 128 ||
     not ((String.length str1) = (String.length str2)) then false
  else (
    for i = 0 to (String.length str1) - 1 do
      let c = str1.[i] in
      match Hashtbl.find_opt mem_table c with
        | None -> Hashtbl.add mem_table c 1
        | Some x -> Hashtbl.replace mem_table c (x + 1)
    done;
    let rec is_permutation2_i str mem_table rslt =
      if String.length str <= 0 || rslt = false then rslt
      else
        let c = str.[0] in
        match Hashtbl.find_opt mem_table c with
        | None -> is_permutation2_i str mem_table false
        | Some x -> 
          if x - 1 < 0 then is_permutation2_i str mem_table false
          else (
            Hashtbl.replace mem_table c (x - 1);
            is_permutation2_i (String.sub str 1 (String.length str - 1)) mem_table true
          )
    in is_permutation2_i str2 mem_table true
  )

(** test
    is_permutation2 "abc" "bca" (* true *)
    is_permutation2 "abc" "bcd" (* false *)
*)
