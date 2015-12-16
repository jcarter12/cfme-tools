for %%I in (evm_current*.tgz)      do  call normalize_current_tgz %%I
for %%I in (evm_full_archive*.tgz) do call normalize_archive_tgz %%I