# -*- coding: utf-8 -*-

<%include file='idx_of.cu.mak' />
<%include file='flux_inv.cu.mak' />

/**
 * Computes the transformed inviscid flux.
 */
__global__ void
tdisf_inv(int nupts, int neles,
          const ${dtype}* __restrict__ u,
          const ${dtype}* __restrict__ smats,
          ${dtype}* __restrict__ f,
          ${dtype} gamma, int ldu, int lds, int ldf)
{
    int eidx = blockIdx.x * blockDim.x + threadIdx.x;

    if (eidx < neles)
    {
        ${dtype} uin[${nvars}], ftmp[${nvars}][${ndims}];

        for (int uidx = 0; uidx < nupts; ++uidx)
        {
            // Load in the soln
            for (int i = 0; i < ${nvars}; ++i)
                uin[i] = u[U_IDX_OF(uidx, eidx, i, neles, ldu)];

            // Compute the flux
            disf_inv(uin, ftmp, gamma, NULL, NULL);

            // Transform and store
            for (int i = 0; i < ${ndims}; ++i)
            {
            % for k in range(ndims):
                ${dtype} s${k} = smats[SMAT_IDX_OF(uidx, eidx, i, ${k}, neles, lds)];
            % endfor

                for (int j = 0; j < ${nvars}; ++j)
                {
                    int fidx = F_IDX_OF(uidx, eidx, i, j, nupts, neles, ldf);
                    f[fidx] = ${' + '.join('s{0}*ftmp[j][{0}]'.format(k)\
                                for k in range(ndims))};
                }
            }
        }
    }
}

