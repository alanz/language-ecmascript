module WebBits.JavaScript.Core where

import Data.Generics

type Id = String

-- |Pure functional
data FOp = OpLT | OpLEq | OpGT | OpGEq  | OpIn  | OpInstanceof | OpEq | OpNEq
  | OpStrictEq | OpStrictNEq | OpLAnd | OpLOr | OpMul | OpDiv | OpMod  | OpSub 
  | OpLShift | OpSpRShift | OpZfRShift | OpBAnd | OpBXor | OpBOr | OpAdd
  | PrefixLNot | PrefixBNot | PrefixMinus | PrefixTypeof | PrefixVoid
  | PrefixDelete | CondOp
  deriving (Show,Data,Typeable,Eq,Ord)

-- |Assignment
data MOp = OpAssign | OpAssignAdd | OpAssignSub | OpAssignMul | OpAssignDiv
  | OpAssignMod | OpAssignLShift | OpAssignSpRShift | OpAssignZfRShift
  | OpAssignBAnd | OpAssignBXor | OpAssignBOr
  deriving (Show,Data,Typeable,Eq,Ord)


data Lit a
  = StringLit a String
  | RegexpLit a String Bool {- global? -} Bool {- case-insensitive? -}
  | NumLit a Double
  | IntLit a Integer
  | BoolLit a Bool
  | NullLit a
  | ArrayLit a [Expr a]
  | ObjectLit a [(Id, Expr a)]
  
data Expr a
  = Lit a
  | This a
  | VarRef a Id
  | DotRef a (Expr a) Id
  | BracketRef a (Expr a) {- container -} (Expr a) {- key -}
  | NewExpr a (Expr a) {- constructor -} [Expr a]
  | OpExpr FOp [Expr a]
  | FuncExpr {
      funcExprX :: a,
      funcExprArgs :: [Id],
      funcExprLocals :: [Id],
      funcExprBody ::  Stmt a
    }
  deriving (Show,Data,Typeable,Eq,Ord)

data Stmt a
  = SeqStmt a [Stmt a]
  | EmptyStmt a
  | AssignStmt a Id MOp [Expr a]
  | CallStmt {
      callStmtX :: a,
      callStmtResultId :: Id,
      callStmtFunctionId :: Id,
      callStmtArgs :: [Id]
    }
  | ExprStmt a (Expr a)
  | IfStmt a (Expr a) (Stmt a) (Stmt a)
  | WhileStmt a (Expr a) (Stmt a)
  | ForInStmt a Id (Expr a) (Stmt a)
  | TryStmt a (Stmt a) Id (Stmt a) {- catch clause -} (Stmt a) {- finally -}
  | ThrowStmt a (Expr a)
  | ReturnStmt a (Expr a)
  deriving (Show,Data,Typeable,Eq,Ord)  
