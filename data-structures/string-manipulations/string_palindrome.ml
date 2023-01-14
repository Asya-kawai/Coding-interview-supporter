(** 与えられた1つ以上の文字列が回文の順列であるかどうかを判定するプログラム 
    入力： Tact Coa
    出力： true （taco cat という文字列を生成できるため）
*)

(**
   ポイント：
   - 回文の順列とはなにか
   - 回文とは： 文字列の前半と後半が同じであること。つまりほぼ全ての文字が偶数回出現すること。また少なくとも1回は特定の文字が出現して良い
   - つまり全て偶数回出現する文字で構成されるか、ある文字が1回出現しそれ以外は全て偶数回出現する文字で構成されるかのどちらか
   - 順列とは： そのままであるが、順序付けて並べたもの

   - 大文字小文字は区別するか
   - ここではしないことにする
   - 空白はどうするか
   - ここでは空白は無視する
*)

(**
   アルゴリズム：

   1. 与えられた文字列を全て小文字にする
   2. 文字列の先頭から1文字取り出し（c）、ハッシュテーブルに記録する。値は+1する。
   3. 文字列が空になったらハッシュテーブルのkey毎に奇数回の出現かどうか（値が奇数かどうか）をチェックし、その総数が1以外であればfalse。そうでなければtrueを返す

   与えられた文字列の長さがnだとすると、ハッシュテーブルへの記録がn回、key毎の捜査が多くともn回発生するので、時間計算量はO(n + n) = O(2n) ~= O(n)となる。
*)

let is_palindrome_pertumation str_list =
  let mem_table = Hashtbl.create 128 in
  (* The function to register in hash_table *)
  let rec register_kv = function
    | [] -> ()
    | x :: xs -> (
      for i = 0 to (String.length x) - 1 do
        let c = x.[i] in
        match Hashtbl.find_opt mem_table c with
        | None -> Hashtbl.add mem_table c 1
        | Some y -> Hashtbl.replace mem_table c (y + 1)
      done;
      register_kv xs
    )
  in (
    (* Register in hash_table *)
    register_kv str_list;
    (* Get keys from hash_table *)
    let keys = Hashtbl.fold (fun x _ z -> x :: z) mem_table [] in
    let rec find_odd is_odd rslt = function
      | [] -> rslt
      | x :: xs ->
        match Hashtbl.find_opt mem_table x with
        | None -> false
        | Some y ->
          if (y mod 2) = 1 then
            if is_odd then find_odd true false [] else find_odd true rslt xs
          else find_odd is_odd rslt xs
    in find_odd false true keys
  )

(** test

    is_palindrome_pertumation ["tact"; "coa"] (* true *)
    is_palindrome_pertumation ["tact"] (* false *)
    is_palindrome_pertumation ["tact"; "coaz"] (* false *)
*)
