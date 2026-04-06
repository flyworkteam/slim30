#!/usr/bin/env bash
set -euo pipefail

cd /Users/muratsag/Developer/Slim30/lib/l10n

for f in app_*.arb; do
  if grep -q '"workoutDetailRemainingLabel"' "$f"; then
    continue
  fi

  case "$f" in
    app_tr.arb)
      rem='Kalan sure'
      comp='Tamamlanan'
      next='Siradaki Hareket'
      ;;
    app_de.arb)
      rem='Verbleibende Zeit'
      comp='Abgeschlossen'
      next='Nächste Übung'
      ;;
    app_es.arb)
      rem='Tiempo restante'
      comp='Completado'
      next='Siguiente movimiento'
      ;;
    app_fr.arb)
      rem='Temps restant'
      comp='Termine'
      next='Mouvement suivant'
      ;;
    app_hi.arb)
      rem='शेष समय'
      comp='पूर्ण'
      next='अगली चाल'
      ;;
    app_it.arb)
      rem='Tempo rimanente'
      comp='Completato'
      next='Mossa successiva'
      ;;
    app_ja.arb)
      rem='残り時間'
      comp='完了'
      next='次の動き'
      ;;
    app_ko.arb)
      rem='남은 시간'
      comp='완료됨'
      next='다음 동작'
      ;;
    app_pt.arb)
      rem='Tempo restante'
      comp='Concluido'
      next='Proximo movimento'
      ;;
    app_ru.arb)
      rem='Оставшееся время'
      comp='Выполнено'
      next='Следующее движение'
      ;;
    app_zh.arb)
      rem='剩余时间'
      comp='已完成'
      next='下一个动作'
      ;;
    *)
      rem='Remaining Time'
      comp='Completed'
      next='Next Move'
      ;;
  esac

  perl -0777 -i -pe 's/\n}\s*$/,\n  "workoutDetailRemainingLabel": "'"$rem"'",\n  "workoutDetailCompletedLabel": "'"$comp"'",\n  "workoutDetailNextMove": "'"$next"'"\n}\n/s' "$f"
done

echo "workout detail l10n keys added"
