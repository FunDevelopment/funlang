/* Generated By:JavaCC: Do not edit this line. FunParserVisitor.java Version 5.0 */
package fun.parser;

public interface FunParserVisitor
{
  public Object visit(SimpleNode node, Object data);
  public Object visit(ParsedRoot node, Object data);
  public Object visit(ParsedStaticText node, Object data);
  public Object visit(ParsedLiteralText node, Object data);
  public Object visit(ParsedSiteStatement node, Object data);
  public Object visit(ParsedCoreStatement node, Object data);
  public Object visit(ParsedDefaultStatement node, Object data);
  public Object visit(ParsedExternStatement node, Object data);
  public Object visit(ParsedAdoptStatement node, Object data);
  public Object visit(ParsedKeepStatement node, Object data);
  public Object visit(ParsedRedirectStatement node, Object data);
  public Object visit(ParsedContinueStatement node, Object data);
  public Object visit(ParsedStaticBlock node, Object data);
  public Object visit(ParsedFunBlock node, Object data);
  public Object visit(ParsedConcurrentFunBlock node, Object data);
  public Object visit(ParsedExternalCollectionDefinition node, Object data);
  public Object visit(ParsedExternalDefinition node, Object data);
  public Object visit(ParsedAnonymousDefinition node, Object data);
  public Object visit(ParsedCollectionDefinition node, Object data);
  public Object visit(ParsedComplexDefinition node, Object data);
  public Object visit(ParsedElementDefinition node, Object data);
  public Object visit(ParsedArguments node, Object data);
  public Object visit(ParsedEllipsis node, Object data);
  public Object visit(ParsedAnonymousArray node, Object data);
  public Object visit(ParsedAnonymousTable node, Object data);
  public Object visit(ParsedTableElement node, Object data);
  public Object visit(ParsedTypeList node, Object data);
  public Object visit(ParsedType node, Object data);
  public Object visit(ParsedName node, Object data);
  public Object visit(ParsedDim node, Object data);
  public Object visit(ParsedDefCollectionName node, Object data);
  public Object visit(ParsedDefTypeName node, Object data);
  public Object visit(ParsedDefElementName node, Object data);
  public Object visit(ParsedParameterList node, Object data);
  public Object visit(ParsedDefParameter node, Object data);
  public Object visit(ParsedAny node, Object data);
  public Object visit(ParsedAnyAny node, Object data);
  public Object visit(ParsedPrimitiveType node, Object data);
  public Object visit(ParsedConditionalExpression node, Object data);
  public Object visit(ParsedWithPredicate node, Object data);
  public Object visit(ParsedWithoutPredicate node, Object data);
  public Object visit(ParsedForExpression node, Object data);
  public Object visit(ParsedIteratorValues node, Object data);
  public Object visit(ParsedDynamicElementBlock node, Object data);
  public Object visit(ParsedValueExpression node, Object data);
  public Object visit(ParsedChoiceExpression node, Object data);
  public Object visit(ParsedBinaryExpression node, Object data);
  public Object visit(ParsedUnaryExpression node, Object data);
  public Object visit(ParsedConstruction node, Object data);
  public Object visit(ParsedBreakStatement node, Object data);
  public Object visit(ParsedNextConstruction node, Object data);
  public Object visit(ParsedSubConstruction node, Object data);
  public Object visit(ParsedSuperConstruction node, Object data);
  public Object visit(ParsedComplexName node, Object data);
  public Object visit(ParsedSpecialName node, Object data);
  public Object visit(ParsedNameWithArguments node, Object data);
  public Object visit(ParsedNameWithIndexes node, Object data);
  public Object visit(ParsedIndex node, Object data);
  public Object visit(ParsedLogicalOrOperator node, Object data);
  public Object visit(ParsedLogicalAndOperator node, Object data);
  public Object visit(ParsedEqualsOperator node, Object data);
  public Object visit(ParsedNotEqualsOperator node, Object data);
  public Object visit(ParsedLessThanOperator node, Object data);
  public Object visit(ParsedGreaterThanOperator node, Object data);
  public Object visit(ParsedLessThanOrEqualOperator node, Object data);
  public Object visit(ParsedGreaterThanOrEqualOperator node, Object data);
  public Object visit(ParsedInOperator node, Object data);
  public Object visit(ParsedLeftShiftOperator node, Object data);
  public Object visit(ParsedRightShiftOperator node, Object data);
  public Object visit(ParsedRightUnsignedShiftOperator node, Object data);
  public Object visit(ParsedAddOperator node, Object data);
  public Object visit(ParsedSubtractOperator node, Object data);
  public Object visit(ParsedMultiplyOperator node, Object data);
  public Object visit(ParsedDivideByOperator node, Object data);
  public Object visit(ParsedModOperator node, Object data);
  public Object visit(ParsedOrOperator node, Object data);
  public Object visit(ParsedXorOperator node, Object data);
  public Object visit(ParsedAndOperator node, Object data);
  public Object visit(ParsedNegateOperator node, Object data);
  public Object visit(ParsedBitflipOperator node, Object data);
  public Object visit(ParsedLogicalNotOperator node, Object data);
  public Object visit(ParsedTypeOperator node, Object data);
  public Object visit(ParsedIsaExpression node, Object data);
  public Object visit(ParsedIntegerLiteral node, Object data);
  public Object visit(ParsedFloatingPointLiteral node, Object data);
  public Object visit(ParsedCharLiteral node, Object data);
  public Object visit(ParsedStringLiteral node, Object data);
  public Object visit(ParsedBooleanLiteral node, Object data);
  public Object visit(ParsedNullLiteral node, Object data);
}
/* JavaCC - OriginalChecksum=125a89a92e8e4beae245e1e41dce4dd9 (do not edit this line) */
