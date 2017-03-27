## 自由研究 その1
And, Orの実装

### Andの簡約規則
* left, right のexpressionをとる
* left がreduce可能ならreduceし、新しいAndを返す. `And(left.reduce, right)`
* left がreduce不可能で、rightがreduce可能なら、rightをreduceし、新しいAndを返す `And(left, right.reduce)`
* `(left == Boolean.new(true)) && (right == Boolean.new(true))` なら `Boolean.new(true)` を返し、そうでなければ `Boolean.new(false)` を返す。
