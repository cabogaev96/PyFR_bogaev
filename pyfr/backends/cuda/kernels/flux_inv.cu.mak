# -*- coding: utf-8 -*-

<%include file='idx_of.cu.mak' />

% if ndims == 3:
/**
 * Compute the inviscid flux.
 */
inline __device__ void
disf_inv(const ${dtype} s[5], ${dtype} f[5][3],
         ${dtype} gamma, ${dtype}* pout, ${dtype} vout[3])
{
    ${dtype} rho = s[0], rhou = s[1], rhov = s[2], rhow = s[3], E = s[4];

    ${dtype} invrho = 1.0/rho;
    ${dtype} u = invrho*rhou, v = invrho*rhov, w = invrho*rhow;

    // Compute the pressure
    ${dtype} p = (gamma - 1.0)*(E - 0.5*(rhou*u + rhov*v + rhow*w));

    f[0][0] = rhou;         f[0][1] = rhov;         f[0][2] = rhow;

    f[1][0] = rhou*u + p;   f[1][1] = rhov*u;       f[1][2] = rhow*u;
    f[2][0] = rhou*v;       f[2][1] = rhov*v + p;   f[2][2] = rhow*v;
    f[3][0] = rhou*w;       f[3][1] = rhov*w;       f[3][2] = rhow*w + p;

    f[4][0] = (E + p)*u;    f[4][1] = (E + p)*v;    f[4][2] = (E + p)*w;

    if (pout != NULL)
    {
        *pout = p;
    }

    if (vout != NULL)
    {
        vout[0] = u; vout[1] = v; vout[2] = w;
    }
}
% endif
