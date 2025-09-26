# 🔍 Inspección de Paquete SUI - TESTNET

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | 2025-09-25 22:12:47 |
| **🌐 Red** | TESTNET |
| **📦 Package ID** | `0x8d2d28a417c0faf3bc176d0972c462e14376c6ec9c446ccb818724c182545b6e` |
| **🎯 Propósito** | Plataforma de votación descentralizada y toma de decisiones |
| **📊 Estado** | ✅ Análisis exitoso |

## 🧩 Módulos (4)
- 📚 `dao`
- 📚 `governance`
- 📚 `proposal`
- 📚 `voting`

## 🔧 Funciones Públicas (55)
- 🔧 `create_dao`
- 🔧 `create_proposal`
- 🔧 `cast_vote`
- 🔧 `execute_proposal`
- 🔧 `mint_governance_token`
- 🔧 `fund_dao`
- 🔧 `get_dao_stats`
- 🔧 `get_treasury_balance`
- 🔧 `has_sufficient_funds`
- 🔧 `get_proposal_votes`
- 🔧 `has_voted`
- 🔧 `get_vote`
- 🔧 `get_dao_info`
- 🔧 `can_execute`
- 🔧 `get_proposal_info`
- 🔧 `get_token_info`
- 🔧 `set_dao_active`
- 🔧 `mint_token`
- 🔧 `validate_token_for_dao`
- 🔧 `validate_voting_power`
- 🔧 `get_token_info`
- 🔧 `get_dao_id`
- 🔧 `get_voting_power`
- 🔧 `get_wrong_dao_token_error`
- 🔧 `get_zero_voting_power_error`
- 🔧 `create_proposal`
- 🔧 `add_vote`
- 🔧 `mark_executed`
- 🔧 `can_execute`
- 🔧 `get_proposal_info`
- 🔧 `get_proposal_votes`
- 🔧 `get_dao_id`
- 🔧 `get_amount`
- 🔧 `get_recipient`
- 🔧 `is_executed`
- 🔧 `get_status`
- 🔧 `proposal_active`
- 🔧 `proposal_approved`
- 🔧 `proposal_rejected`
- 🔧 `proposal_executed`
- 🔧 `create_voting_record`
- 🔧 `cast_vote`
- 🔧 `has_voted`
- 🔧 `calculate_result`
- 🔧 `get_vote_info`
- 🔧 `get_voting_stats`
- 🔧 `get_proposal_id`
- 🔧 `get_voter`
- 🔧 `get_vote_type`
- 🔧 `get_voting_power_used`
- 🔧 `get_vote_timestamp`
- 🔧 `get_voting_not_started_error`
- 🔧 `get_voting_ended_error`
- 🔧 `get_invalid_vote_type_error`
- 🔧 `get_already_voted_error`

## 📐 Estructuras (17)
- 📐 `DAO (key )`
- 📐 `Proposal (key )`
- 📐 `GovernanceToken (store, key )`
- 📐 `Vote (store, key )`
- 📐 `DAOCreated (copy, drop )`
- 📐 `ProposalCreated (copy, drop )`
- 📐 `VoteCast (copy, drop )`
- 📐 `ProposalExecuted (copy, drop )`
- 📐 `GovernanceToken (store, key )`
- 📐 `GovernanceTokenMinted (copy, drop )`
- 📐 `Proposal (store, key )`
- 📐 `ProposalCreated (copy, drop )`
- 📐 `ProposalExecuted (copy, drop )`
- 📐 `Vote (store, key )`
- 📐 `VotingRecord (store, key )`
- 📐 `VoteCast (copy, drop )`
- 📐 `VotingRecordCreated (copy, drop )`

## 💡 Casos de Uso Sugeridos
- � Votación en organizaciones descentralizadas (DAOs)
- � Sistemas de propuestas comunitarias
- � Gobernanza de protocolos DeFi
- � Decisiones democráticas en blockchain

## 🎯 Tipo de Sistema Detectado

**Sistema de Gobernanza y Votación**

Plataforma de votación descentralizada y toma de decisiones

## �🔗 Enlaces Útiles

- 🌐 **SUI Explorer Package**: [Ver en Explorer](https://suiexplorer.com/object/0x8d2d28a417c0faf3bc176d0972c462e14376c6ec9c446ccb818724c182545b6e?network=testnet)
- 📊 **SuiVision Explorer**: [Ver en SuiVision](https://suivision.xyz/package/0x8d2d28a417c0faf3bc176d0972c462e14376c6ec9c446ccb818724c182545b6e?network=testnet)
- 🔧 **Interacción CLI**: `sui client call --package 0x8d2d28a417c0faf3bc176d0972c462e14376c6ec9c446ccb818724c182545b6e --module [MODULE] --function [FUNCTION]`

## 📈 Estadísticas del Análisis

| Métrica | Valor |
|---------|-------|
| 📚 **Módulos Detectados** | 4 |
| 🔧 **Funciones Públicas** | 55 |
| � **Estructuras** | 17 |
| 💡 **Casos de Uso** | 4 |
| 🕐 **Tiempo de Análisis** | < 5 segundos |

---

**�📋 Reporte generado automáticamente por inspect-package.ps1 v3.0**  
**🤖 Análisis dinámico inteligente de bytecode SUI Move**  
**⏰ 2025-09-25 22:12:47**
