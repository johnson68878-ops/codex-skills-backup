"""Synthetic independent-group comparison; no device measurements."""
import json
import numpy as np
from scipy import stats
rng = np.random.default_rng(20261117)
a = rng.normal(10, 1, 40)
b = rng.normal(10.7, 1.5, 45)
result = stats.ttest_ind(a, b, equal_var=False)
v1, v2 = a.var(ddof=1)/len(a), b.var(ddof=1)/len(b)
se = np.sqrt(v1+v2)
df = (v1+v2)**2/(v1**2/(len(a)-1)+v2**2/(len(b)-1))
delta = a.mean()-b.mean()
assert np.isclose(result.statistic, delta/se)
assert np.isclose(result.pvalue, 2*stats.t.sf(abs(delta/se),df))
ci = result.confidence_interval()
assert np.allclose([ci.low,ci.high], delta+np.array([-1,1])*stats.t.ppf(.975,df)*se)
pooled = np.sqrt(((len(a)-1)*a.var(ddof=1)+(len(b)-1)*b.var(ddof=1))/(len(a)+len(b)-2))
d = delta/pooled
assert np.isfinite(d)
print(json.dumps({'data':'synthetic','seed':20261117,'n':[len(a),len(b)],'mean_difference_A_minus_B':float(delta),'welch_t':float(result.statistic),'p_two_sided':float(result.pvalue),'ci95':[float(ci.low),float(ci.high)],'cohen_d_descriptive':float(d),'shapiro_p':[float(stats.shapiro(a).pvalue),float(stats.shapiro(b).pvalue)],'levene_p':float(stats.levene(a,b).pvalue),'checks':'Welch statistic, p-value and CI independently cross-checked'},indent=2))
